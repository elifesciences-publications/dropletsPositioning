#!/bin/bash
dirName="$1"
Nlines=`wc -l < "$dirName/filters.txt"`
echo "performaing auto analysis on $Nlines montages"
for i in `seq 1 $Nlines`; do
    echo "$i"
    ./qsub_bigdrops.sh "$dirName" $i
done
