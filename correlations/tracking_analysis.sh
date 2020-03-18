#!/bin/bash
#PBS -e /home/niv/qsub_out/$PBS_JOBNAME-$PBS_JOBID.out
#PBS -o /home/niv/qsub_out/$PBS_JOBNAME-$PBS_JOBID.err
DIR="$(readlink -f "${1-~}")"
cd  ~nivieru/emulsions/emulsions_analysis
/usr/local/bin/matlab -nodesktop -r "tracking_wrapper_oop('$DIR',[],[$2]);quit;" >& "$DIR/tracking_analysis.out"
#/usr/local/bin/matlab -nodesktop -r "test_bash('$DIR/params.txt', '$montageName');quit;" >& $DIR/test_$montageName.out


