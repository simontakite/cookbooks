#!/bin/bash

# -------------------------------------	#
# 	cprintstats.sh by torad		#
# ------------------------------------ 	#
# Purpose:				#
# - Display color printing stats	#
# Input: 				#
# - Path to job log (.csv)		#
# ------------------------------------- #

if [ -z $1 ];then
   echo "Usage: $0 <joblog.csv>"
   exit 1
fi

joblog=$1

# Store each computer name in an array
comps=($(cat $joblog|tr -d "\""|tr -d [:blank:]|cut -d "," -f3|sort|uniq))

# Create a parallel array with initial value of 0 for each element
declare -a vals
count=0
stop=${#comps[*]}
while (( "$count" < "$stop" ));do
   vals[$count]=0
   let count++
done

for line in $(cat $joblog|tr -d "\""|tr -d [:blank:]|cut -d "," -f 2,3,9);do # Field 8=b/w 9=color
   # Select only prints (not copies)
   jobtype=$(echo $line|cut -d "," -f1)
   if [ $jobtype == "Print"  ];then
      # Select only color prints
      cpages=$(echo $line|cut -d "," -f3)
      if (( $cpages > 0 ));then
         # Match current computer name to the computers array and assign
         #+ the color page count to its parallel in the value array
         rcomp=$(echo $line|cut -d "," -f2)
         rval=$(echo $line|cut -d "," -f3)
         r=0
         while (( "$r" < "$stop" ));do
            if [ ${comps[$r]} == $rcomp ];then
               let vals[$r]+=$rval
               r=$stop
            fi
            let r++
         done
      fi
   fi
done

# Print each computer and its corresponding count
t=0
while (( "$t" < "$stop" ));do
   echo "${comps[$t]}: ${vals[$t]}"
   let t++
done
