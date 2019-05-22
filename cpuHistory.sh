#!/bin/zsh

cpuActivity >> /tmp/cpu.log
tail -n 20 "/tmp/cpu.log" | tee "/tmp/cpu.log"
