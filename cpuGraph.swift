#!/usr/bin/env xcrun swift

//
//  main.swift
//  CPUActivity
//
//  Created by zephyz on 22.05.19.
//  Copyright © 2019 zephyz. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreImage
import AVFoundation

let pictureHeight = 44
let pictureWidth = 40
let coreCount = 4

func getCPUHistory() -> String? {
    return try? String(contentsOfFile: "/tmp/cpu.log", encoding: .utf8)
}
func parsePercent<S: StringProtocol>(_ str: S) -> Float? {
    return Float.init(str.dropLast())
}

func parseDataString(_ data: String) -> [Float]{
    return data.split(separator: "\n").compactMap(parsePercent)
}

// remove the n first element until the size is reached
// add n elements in the front until the size is reached
func setSize<T>(_ array: [T], size: Int, defaultValue: T) -> [T] {
    let diff = array.count - size
    if diff < 0 {
        return Array(repeating: defaultValue, count: -diff) + array
    } else if diff > 0 {
        return Array(array.dropFirst(diff))
    } else {
        return array
    }
}

func handleAllData() -> [Float] {
    let parsed = parseDataString(getCPUHistory()!).map { $0 / (coreCount * 100)}
    return setSize(parsed, size: 20, defaultValue: 0)
}

public struct PixelData {
    var a:UInt8 = 255
    var r:UInt8
    var g:UInt8
    var b:UInt8
}


let transparent = PixelData(a: 0, r: 0, g: 0, b: 0)
let white = PixelData(a: 255, r: 255, g: 255, b: 255)

struct SimpleImage {
    let width: Int
    let height: Int
    let data: [PixelData]
}

func makeImage(data: [Float], width: Int, height: Int) -> SimpleImage {
    let barWidth = width/data.count
    var image = Array.init(repeating: transparent, count: width * height)
    for (i, v) in data.enumerated() {
        let columnHeight = Int(v * Float(height))
        for barOffset in 0..<barWidth {
            for h in 0..<columnHeight {
                let x = ((i*barWidth)+barOffset)
                let y = h
                image[x + width * (height - 1) - (y * width)] = white
            }
        }
    }
    return SimpleImage(width: width, height: height, data: image)
}

private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

func imageFromARGB32Bitmap(image: SimpleImage) -> CGImage? {
    let pixels = image.data
    let width = image.width
    let height = image.height
    let bitsPerComponent: Int = 8
    let bitsPerPixel: Int = 32

    assert(pixels.count == Int(width * height))

    var data = pixels // Copy to mutable []
    let providerRef = CGDataProvider(
        data: NSData(bytes: &data, length: data.count * MemoryLayout<PixelData>.size)
    )

    return CGImage(
        width: width,
        height: height,
        bitsPerComponent: bitsPerComponent,
        bitsPerPixel: bitsPerPixel,
        bytesPerRow: width * Int(MemoryLayout<PixelData>.size),
        space: rgbColorSpace,
        bitmapInfo: bitmapInfo,
        provider: providerRef!,
        decode: nil,
        shouldInterpolate: true,
        intent: CGColorRenderingIntent.defaultIntent
    )
}

let destinationString = "/tmp/cpulogimage.heic"
let destinationURL = URL.init(fileURLWithPath: destinationString)

let img = makeImage(data: handleAllData(), width: 40, height: 44)

struct BTTMessage: Codable {
    let text: String?
    let icon_path: String?
    let background_color: String?
    let font_color: String?
    let font_size: String?
}

let imageContent = BTTMessage(text: "​", icon_path: destinationString, background_color: nil, font_color: "255,255,255,255", font_size: nil)

func saveImageToDisk(url: CFURL, image: CGImage) {

    guard let dest = CGImageDestinationCreateWithURL(url, AVFileType.heic as CFString, 1, nil) else { return };
    let lossless = [kCGImageDestinationLossyCompressionQuality as String: 1.0] as CFDictionary
    CGImageDestinationAddImage(dest, image, lossless)
    CGImageDestinationFinalize(dest)

    let json = JSONEncoder()
    let encoded = try? json.encode(imageContent)
    let encodedString = String(data: encoded!, encoding: .utf8)!
//    let escaped = encodedString.replacingOccurrences(of: "\"", with: "\\\"")
    print(encodedString)

}

saveImageToDisk(url: destinationURL as CFURL, image: imageFromARGB32Bitmap(image: img)!)

