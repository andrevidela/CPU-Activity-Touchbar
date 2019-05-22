#!/bin/bash
BIN_LOCATION=$1;
CURRENT=$(PWD)

ln -s $PWD/cpuActivity.sh $BIN_LOCATION/cpuActivity
ln -s $PWD/cpuHistory.sh $BIN_LOCATION/cpuHistory
ln -s $PWD/cpuGraph.swift $BIN_LOCATION/cpuGraph
