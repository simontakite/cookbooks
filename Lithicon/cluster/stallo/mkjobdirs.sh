#!/bin/bash

# mkjobdirs.sh for stallo jobs / erasmus by torad

# We have 8 subsamples for 3 grids, 24 subsamples total.
# For each subsample, create a job directory for
# - absperm-x
# - absperm-y
# - absperm-z
# - rwabsperm
# - rwff
#
# link the grid from the source dir
# copy the input file from the source dir

# Set output path
outpath="/home/steel/work/erasmus/jobs"
inputpath="/home/steel/work/erasmus/input"
gridpath="/home/steel/work/erasmus/subsamples"

for subsample in $(ls -l|grep ^d|awk '{print $9}');do
   # Create job directories for the absperm jobs
   for direction in X Y Z;do
      newdir="$outpath/$subsample-absperm-$direction"
      mkdir $newdir
      cp $inputpath/absperm/$direction/lb3d.par $newdir
      ln -s $gridpath/$subsample/grid.dat $newdir/grid.dat
   done
   # Create job directory for the rwabsperm job
   newdir="$outpath/$subsample-rwabsperm"
   mkdir $newdir
   cp $inputpath/rwabsperm/permRW.par $newdir
   ln -s $gridpath/$subsample/grid.dat $newdir/grid.dat
   # Create job directory for the rwff job
   newdir="$outpath/$subsample-rwff"
   mkdir $newdir
   cp $inputpath/rwff/inputRW.par $newdir
   ln -s $gridpath/$subsample/grid.dat $newdir/grid.dat
done
