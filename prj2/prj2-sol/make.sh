#!/bin/sh

path=`realpath $0`
dir=`dirname $path`

# $dir now refers to the directory in which this script actually lives

cd "$dir"
g++ -std=c++11 -Wall main.cpp -o main.out