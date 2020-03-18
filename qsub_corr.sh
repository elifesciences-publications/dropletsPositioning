#!/bin/bash
echo $"~/code/correlations.sh \"$1\" $2 " | qsub -q main -N corr
