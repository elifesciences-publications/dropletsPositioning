#!/bin/bash
echo "Dir: $1" >> "qsub_montage_wrapper.out"
echo "Line: $2" >> "qsub_montage_wrapper.out"
echo $"~nivieru/emulsions/emulsions_analysis/montage_wrapper.sh \"$1\" \"$2\"" | qsub -q short -N montage_wrapper
