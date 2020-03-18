#!/bin/bash
echo $"~/code/auto_analysis.sh \"$1\" $2" | qsub -q main -N drop_detection
