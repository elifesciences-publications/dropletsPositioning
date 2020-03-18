#!/bin/bash
echo $"~/code/tracking_analysis.sh \"$1\" $2 " | qsub -q main -N tracking
