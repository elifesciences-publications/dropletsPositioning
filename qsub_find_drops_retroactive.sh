#!/bin/bash
echo "~/code/find_drops_retroactive.sh $1 $2" | qsub -q main -N find_drops
