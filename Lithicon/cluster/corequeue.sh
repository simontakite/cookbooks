#!/bin/bash

# ----------------------------------------------------- #
# corequeue.sh by torad					#
# ----------------------------------------------------- #
# Created:	28.09.2009				#
# Changed:	06.12.2010				#
# Type:		Cluster - utility			#
# ----------------------------------------------------- #
# Purpose:						#
# - Display realtime cluster job queue stats		#
# Dependencies:						#
# - qconf and qstat in $PATH				#
# - host registered in SGE as admin host or submit host #
# ----------------------------------------------------- #

# Test dependencies 
which qconf &> /dev/null
(( $? != 0 )) && echo "qconf not found. Verify that it exists in \$PATH." && exit 1

qconf -ss &> /dev/null
(( $? != 0  )) && echo "Access denied. Make sure this host is configured for cluster access." && exit 1


# --Get total cores
tCoreCount=$(qconf -sep|tail -n1|tr -s '[:blank:]' ";"|cut -d ";" -f 2)

# --Get disabled cores
#dCores=($(qstat -f -qs d|head -n5|sed '1,2d'|sed '2,1d'|tr -s '[:blank:]' ";"|cut -d ";" -f 3|sed 's/[0/]//g'))
dCores=($(qstat -f -qs d|grep compute|tr -s '[:blank:]' ";"|cut -d ";" -f 3|sed 's/[0/]//g'))
dCoreCount=0
a=0

while [ $a -lt ${#dCores[*]} ];do
   dCoreCount=$(($dCoreCount + ${dCores[$a]}))
   let a++
done

# --Calculate active cores
qCoreCount=$(($tCoreCount - $dCoreCount))

# --Get number of running/queued jobs
rJobs=$(qstat -s r|sed '1,2d'|wc -l)
qwJobs=$(qstat -s p|sed '1,2d'|wc -l)

# --Count cores in use
#rCores=($(qstat -s r|sed '1,2d'|tr -s '[:blank:]' ";"|cut -d ";" -f 10))
rCores=($(qstat -s r|sed '1,2d'|awk '{print $NF}'))
rCoreCount=0
i=0

while [ $i -lt ${#rCores[*]} ];do
   rCoreCount=$(($rCoreCount + ${rCores[$i]}))
   let i++
done

# --Count cores in demand
#qwCores=($(qstat -s p|sed '1,2d'|tr -s '[:blank:]' ";"|cut -d ";" -f 9))
qwCores=($(qstat -s p|sed '1,2d'|awk '{print $NF}'))
qwCoreCount=0
j=0

while [ $j -lt ${#qwCores[*]} ];do
   qwCoreCount=$(($qwCoreCount + ${qwCores[$j]}))
   let j++
done

# --Output section
echo
echo Core and Job status - Lima Cluster:
echo "-------------------------------------"
echo -n "Total number of cores:"
echo -n $'\t' $'\t'
echo $tCoreCount
echo -n "Number of enabled cores:"
echo -n $'\t'
echo $qCoreCount
echo -n "Number of cores in use:"
echo -n $'\t' $'\t'
echo $rCoreCount
echo -n "Number of cores in demand:"
echo -n $'\t'
echo $qwCoreCount
echo -n "Number of running jobs:"
echo -n $'\t' $'\t'
echo $rJobs
echo -n "Number of waiting jobs:"
echo -n $'\t' $'\t'
echo $qwJobs
echo
