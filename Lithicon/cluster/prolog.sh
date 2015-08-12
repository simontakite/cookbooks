#!/bin/bash

# --------------------------------------------- #
# prolog.sh by torad				#
# --------------------------------------------- #
# Created:	15.07.2008			#
# Changed:	19.10.2010			#
# Type:		Cluster - SGE prolog script	#
# --------------------------------------------- #
# Purpose:					#
# - decompress grid.binc if necessary 		#
# Usage:					#
# - automatically invoked by SGE		#
# --------------------------------------------- #

unpacker=/net/software/e-Core/ecore-1.5rc1/bin/unpacker
unpackerlibs=/net/software/e-Core/ecore-1.5rc1/lib
binc="grid.binc"
dat="grid.dat"
exitcode=0

#Check parameter files for the word 'grid' and place the word (incl. extension) in the datafile variable. If there is no .par file, assume grid.binc
if $(ls -l|grep -q .par);then
#if [ -f "*.par" ];then
   #datafile=$(cat *.par|grep grid|sed 's/\s.*//'|head -n 1)
   datafile=$(cat *.par|grep grid|awk {'print $1'}|sort|uniq|tail -n1)
else
   datafile=$binc
fi

echo "--- Prolog started $(date +%H:%M:%S) on $(hostname) ---"

if [ -f "$datafile" ];then
   echo "Data file $datafile found. No action needed."
else
   # If data file = grid.dat and it doesn't exist yet, decompress grid.binc
   if [[ "$datafile" == "$dat" ]];then
      if [ -f $binc ];then
         export LD_LIBRARY_PATH=$unpackerlibs:$LD_LIBRARY_PATH
         echo "Inflating $dat from $binc..."
         $unpacker $binc $dat
         unpackstat=$?
         # Put the job in (E)rror state if the unpacker did not return 0
         if (( $unpackstat != 0  ));then
            exitcode=100
            echo "Error: The unpacker exited with status $unpackstat."
         else
            echo "Done."
         fi
      else
         echo "Error: Source file $binc not found. Calculation will fail."
      fi
   else
      echo "Error: Data file $datafile not found. Calculation will fail."
   fi
fi

echo "--- Prolog ended $(date +%H:%M:%S) ---"

exit $exitcode
