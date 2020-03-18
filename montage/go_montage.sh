#!/bin/bash
dirName="$1"
Nlines=`wc -l < "$dirName/filters.txt"`
echo "dirMame: $dirName"
echo "building $Nlines montages"
for i in `seq 1 $Nlines`; do
    echo "$i"
    ./qsub_montage_wrapper.sh "$dirName" $i
done
