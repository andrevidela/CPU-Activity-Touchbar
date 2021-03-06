# CPU-Activity-Touchbar
Utilities to enable CPU Activity as a touchbar widget

![screenshot example](screenshot_example.png)

This allows the touchbar to display a graph of the CPU activity over the last 100 seconds by interval of 5 seconds.

## cpuActivity

This utility simply returns the CPU activity in percent (%) beware that this is the sum of the 
activity percentage of each of your cores, so if you have 4 cores. Your maximum activity is 400%

## cpuHistory

This utility add the current CPU activity to the `/tmp/cpu.log` file and only keep the last 20 entries.
It also prints the content of the file to stdout.

## cpuGraph

This script reads off the `/tmp/cpu.log` file, parses it, and generates a graph in `heic` format at
location `/tmp/cpulogimage.heic`. It also prints out the JSON file that will be interpreted by BTT
in order to update the icon in the touchbar with the new image.

Since my own laptop has 4 cores I divide the percentage by 400. If you have more (or less) cores you might want to change the "coreCount" variable in this file.

# Installation

Pull the project with
```sh
git pull https://github.com/andrevidela/CPU-Activity-Touchbar.git
```

Then go into its directory

```sh
cd CPU-Activity-Touchbar
```

Here, you can use the `install.sh` script to symlink those utilities to your location of your preference by giving it
the path as argument. I personally put them in `/usr/local/bin`. Which means I use the script like that

```sh
sh install.sh /usr/local/bin
```

## Better Touch Tool installation

In order for this to work you will need BetterTouchTool and you will have to add a new button in your touchbar.

1. First create a new TouchBar trigger
2. Select `TouchBar Widget` and then `Shell script/Task widget`
3. In the `Script` field enter the following program: 
```sh
cpuHistory > /dev/null
cpuGraph
```

You can tweak the refresh rate by selecting another time interval.
