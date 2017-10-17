#!/bin/bash

stlFile=$1
layerThickness=$2
numLayers=$3

if [ "$stlFile"         == "" -o \
     "$layerThickness"  == "" -o \
     "$numLayers"       == "" ]; then
    echo "ERROR: Please specify STL file, layer thickness (mm), and number of layers"
    exit 1
fi

if ! [ -f $stlFile ]; then
    echo "ERROR: Specified file does not exist"
    exit 1
fi

if ! [ ${stlFile: -4} == ".stl" ]; then 
    echo "ERROR: Specified file is not an STL file"
    exit 1
fi

loadingBar() {
    progress=$1
    max=$2
    size=$3
    count=0

    echo -n "["
    while [ $count -lt $(($progress * $size / $max)) ]; do
        echo -n "="
        count=$((count + 1))
    done
    echo -n ">"
    while [ $count -lt $size ]; do
        echo -n "."
        count=$((count + 1))
    done
    echo -ne "]\r"
}

outputDirectory=$(basename $stlFile .stl)Projections
mkdir -p $outputDirectory
layerNumber=0

while [ $layerNumber -le $numLayers ]; do
    loadingBar $layerNumber $numLayers 50

    openscad \
        -o $outputDirectory/layer$layerNumber.png \
           generateProjections.scad \
        --imgsize=1920,1080 \
        --camera=-40,0,10,90,0,0,95 \
        -D "stlFile=\"$stlFile\"" \
        -D "layerThickness=$layerThickness" \
        -D "layerNumber=$layerNumber" \
        &> /dev/null
        # --autocenter \
        # --viewall \

    layerNumber=$((layerNumber + 1))
done

echo -ne '\n'
echo 'Projections complete'
