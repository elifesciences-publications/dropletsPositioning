#!/bin/bash
#PBS -e /home/niv/qsub_out/test.err
#PBS -o /home/niv/qsub_out/test.out
DIR="$(readlink -f "${1-~}")"
M=$2
cd  ~nivieru/emulsions/emulsions_analysis
echo "123" >& "$DIR/test.out"
#/usr/local/bin/matlab -nodesktop -r "test_bash('$DIR/params.txt', '$montageName');quit;" >& $DIR/test_$montageName.out


