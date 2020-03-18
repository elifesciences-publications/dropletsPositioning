#!/bin/bash
#PBS -e /home/niv/qsub_out/$PBS_JOBNAME-$PBS_JOBID.out
#PBS -o /home/niv/qsub_out/$PBS_JOBNAME-$PBS_JOBID.err
DIR="$(readlink -f "${1-~}")"
M=$2
cd  ~nivieru/emulsions/emulsions_analysis
/usr/local/bin/matlab -nodesktop -r "bigdrops_wrapper('$DIR/params.txt', $M);quit;" >& "$DIR/emulsion_analysis_Line$M.out"
#/usr/local/bin/matlab -nodesktop -r "test_bash('$DIR/params.txt', '$montageName');quit;" >& $DIR/test_$montageName.out


