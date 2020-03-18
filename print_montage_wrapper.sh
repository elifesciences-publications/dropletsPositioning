#!/bin/bash
cd  ~nivieru/emulsions/emulsions_analysis
/usr/local/bin/matlab -nodesktop -r "print_montage('$1');quit;" >& ~nivieru/print_montage_wrapper.out
#echo "$DIR - $LINE - $montageName" >& $DIR/montage_wrapper_test.out

