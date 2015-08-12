#!/bin/bash
# -----------------------------------------------------	#
# dem-series.sh by torad	last update: 08.10.2009	#
# -----------------------------------------------------	#
# Purpose:						#
# - Run a series of $np DEM_sphere_GPU simulations,	#
#   while managing input/output files			#
# Required input:					#
# - number of samples/simulations			#
# -----------------------------------------------------	#
me=$(basename $0)

# Check input
if [ -z $1 ];then
   echo "Usage: $me <number of samples>"
   exit 1
fi

# Verify input
np=$1
if echo $np|egrep -q -v '^[0-9][0-9]*$';then
   echo "Illegal argument: $np"
   exit 2
fi

# Check binary
run="./DEM_sphere_GPU"
[ ! -f $run ] && echo "Missing binary: $run" && exit 3

# Check file pairs
demsettings="DEMsettings"
demsizes="grainsizes"
p=1
while (( $p <= $np ));do
   (( $p < 10 )) && zero="0" || zero=""
   checkset=$demsettings"_"$zero$p".txt"
   checksiz=$demsizes"_"$zero$p".txt"
   [ ! -f $checkset ] && echo "Missing input file: $checkset" && exit 3
   [ ! -f $checksiz ] && echo "Missing input file: $checksiz" && exit 3 
   let p++
done

# Run the simulations
outfile=$me".out"
demout1="eCoreInputFile"
demout2="SettingsConfigRestartFile"
demout3="Snapshot"
demout4="surfaceFile"
echo "" > $outfile
p=1

while (( $p <= $np ));do
   (( $p < 10 )) && zero="0" || zero=""
   runsettings=$demsettings"_"$zero$p".txt"
   runsizes=$demsizes"_"$zero$p".txt"
   echo "Simulation $p of $np started on $(date '+%d.%m.%Y at %H:%M:%S')"
   echo "Simulation $p of $np started on $(date '+%d.%m.%Y at %H:%M:%S')" >> $outfile
   cp $runsettings $demsettings".txt"
   cp $runsizes $demsizes".txt"
   $run >> $outfile
   # Save output files, if existing   
   sleep 1
   [ -f "$demout1.txt" ] && mv $demout1".txt" $demout1"_"$zero$p".txt"
   [ -f "$demout2.txt" ] && mv $demout2".txt" $demout2"_"$zero$p".txt"
   [ -f "$demout3.txt" ] && mv $demout3".txt" $demout3"_"$zero$p".txt"
   [ -f "$demout4.txt" ] && mv $demout4".txt" $demout4"_"$zero$p".txt"
   sleep 1
   let p++
done

exit 0
