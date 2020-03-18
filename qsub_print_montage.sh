#!/bin/bash
filename=$(readlink -f $1)
echo "~/code/print_montage_wrapper.sh $filename" | qsub -q short -N print_montage
