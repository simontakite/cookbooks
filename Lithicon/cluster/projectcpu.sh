#!/bin/bash

# ---------------------------------------------------- #
# projectcpu.sh by torad	last edit: 11.03.2009  #
# ---------------------------------------------------- #
# Expected input <MMDD> (startdate) <MMDD> (stopdate)  #
# example: ./projectcpu.sh 0301 0331		       #
# default: previous month			       #
# ---------------------------------------------------- #

#Figure out the previous month
thisMo=$(date +%m)

#Check input
if [ "$1" != "" ];then
   startdate=$1
   if [ "$2" != "" ];then
      stopdate=$2
   else
      # --only start date was given, set stop date to last day of month given in start date
      startMo=$(echo $startdate|fold -w2|head -n1)
      # --last day in start month
      case "$startMo" in
         02)
            lastDomS="28"
            ;;
         04|06|09|11)
            lastDomS="30"
            ;;
         *)
            lastDomS="31"
            ;;
      esac
      stopdate="${startMo}${lastDomS}"
      echo "** Stop date not given. Using $stopdate."
   fi
else
# --no dates were given, use previous month
if (( "$thisMo" < 11 )); then
   # --when subtracting the leading '0' is lost
   prevMo="0$(($thisMo - 1))"
else
   prevMo=$(($thisMo -1))
fi
# --last day in previous month
case "$prevMo" in
   02)
      lastDomP="28"
      ;;
   04|06|09|11)
      lastDomP="30"
      ;;
   *)
      lastDomP="31"
      ;;
esac
   startdate="${prevMo}01"
   stopdate="${prevMo}${lastDomP}"
   echo "** Start/stop date not given. Using $startdate - $stopdate."
fi

#Set qacct argument vars
begintime="${startdate}0000"
endtime="${stopdate}2359"

#Put accounts/project numbers in an array
projects=($(qacct -j|grep account|sort|uniq|sed 's/account\s*//'))

#Count number of elements in the array
len=${#projects[*]}
i=0

echo
echo -n "Project ID"; echo -n $'\t'; echo "CPU seconds spent between $startdate and $stopdate"
echo "-------------------------------------------------------"

while [ $i -lt $len ];do
   # --- Omit projects on which no computing occured within the reporting period ---
   rows=$(qacct -A ${projects[$i]} -b $begintime -e $endtime|wc -l)
   if [ $rows -gt 3 ];then
      # --- Output CPU seconds for the project
      cpusec=$(qacct -A ${projects[$i]} -b $begintime -e $endtime|tail -n1|tr -s [:space:] "\n"|tail -n 4|head -n 1)
      echo -n "${projects[$i]}:"
      pnlen=$(echo ${projects[$i]}|fold -w1|wc -l)
      if (( $pnlen < 7 ));then
         echo -n $'\t'
      fi
      echo -n $'\t'
      echo "$cpusec"
   fi
   let i++
done
echo
