#!/bin/bash
BIN_LOCATION=$1;
CURRENT=$(PWD)

chmod +x $PWD/cpuActivity.sh
chmod +x $PWD/cpuHistory.sh
chmod +x $PWD/cpuGraph.sh

ln -s $PWD/cpuActivity.sh $BIN_LOCATION/cpuActivity
ln -s $PWD/cpuHistory.sh $BIN_LOCATION/cpuHistory
ln -s $PWD/cpuGraph.swift $BIN_LOCATION/cpuGraph
