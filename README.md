# CPU-Activity-Touchbar
Utilities to enable CPU Activity as a touchbar widget


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

# Installation

You can use the `install.sh` script to symlink those utilities to your location of your preference by giving it the path as argument. I personally put them in `/usr/local/bin`. Which means I use the script like that

```sh
./install.sh /usr/local/bin
```

You might want to make all these executable so you probably need

```sh
chmod -x cpuActivity.sh cpuGraph.swift cpuHistory.sh install.sh
```
