#!/bin/bash
DIR=$(readlink -f ${1-~})
M=$2
cd  ~nivieru/emulsions/emulsions_analysis
/usr/local/bin/matlab -nodesktop -r "find_drops_in_montage('$DIR', $M);quit;" >& $DIR/find_drops$M.out
