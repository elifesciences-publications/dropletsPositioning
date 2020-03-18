#!/bin/bash
#PBS -e /home/niv/qsub_out/$PBS_JOBNAME-$PBS_JOBID.out
#PBS -o /home/niv/qsub_out/$PBS_JOBNAME-$PBS_JOBID.err
DIR=`dirname "$1"`
cd  ~nivieru/emulsions/emulsions_analysis
/usr/local/bin/matlab -nodesktop -r "correlations_wrapper('$1',$2);quit;" >& "$DIR/correlations.out"
