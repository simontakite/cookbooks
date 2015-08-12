#!/bin/bash

#--------------------------------------------#
# Copy from old to new storage (test script) #
#--------------------------------------------#

ts05="/home/technicalservices/Year2005"
ts06="/home/technicalservices/Year2006"
ts07="/home/technicalservices/Year2007"
ts08="/home/technicalservices/Year2008"
tsnew="/net/projects/ts"

C="cp -ru"
R="rsync -lort --delete-after"

### Copy Year 2005 ###

S2005=( "$ts05/RWE_DEA/" "$ts05/ScannedTSimages" "$ts05/Statoil/" )
D2005=( "$tsnew/RWE_DEA/Y2005/" "$tsnew/unsorted/Year2005/" "$tsnew/StatoilHydro/Y2005/" )

i=0

while [ $i -lt ${#S2005[*]} ]; do
echo  "$C ${S2005[$i]}* ${D2005[$i]}"
echo  "$R ${S2005[$i]} ${D2005[$i]}"   
   let i=i+1
done

echo "cp $ts05/Org\ Ourhoud.doc $tsnew/Ourhoud/Y2005/"

### Copy Year 2006 ###

S2006=( "$ts06/Hydro/" "$ts06/Ourhoud/" "$ts06/PDO/" "$ts06/RWE_DEA/" "$ts06/SA/" "$ts06/Statoil/" "$ts06/Total/" )
D2006=( "$tsnew/StatoilHydro/Y2006/" "$tsnew/Ourhoud/Y2006/" "$tsnew/PDO/Y2006/" "$tsnew/RWE_DEA/Y2006/" "$tsnew/SaudiAramco/Y2006/" "$tsnew/StatoilHydro/Y2006" "$tsnew/Total/Y2006/" )

i=0

while [ $i -lt ${#S2006[*]} ]; do
echo   "$C ${S2006[$i]}* ${D2006[$i]}"
echo   "$R ${S2006[$i]} ${D2006[$i]}"  
   let i=i+1
done
