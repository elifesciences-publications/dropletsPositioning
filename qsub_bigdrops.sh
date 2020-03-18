#!/bin/bash
echo $"~/code/bigdrops_analysis.sh \"$1\" $2" | qsub -q main -N bigdrops
