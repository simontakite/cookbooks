#!/bin/bash

# ------------------------------------------------------------- #
# check_sge_status by torad					#
# ------------------------------------------------------------- #
# Created:	2009						#
# Changed:	23.04.2010					#
# Type:		nagios - information + monitoring		#
# Notes:	based on corequeue.sh by torad			#
# ------------------------------------------------------------- #
# Purpose: 							#
# - Display queue status (cstat/corequeue.sh equiv)		#
# - Monitor job status (check for job errors)			#
# - Monitor node status (check for node errors)			#
# ------------------------------------------------------------- #

# Set path
export PATH=/opt/gridengine/bin/lx26-amd64:$PATH

# Set SGE environemt
export SGE_EXECD_PORT=537
export SGE_QMASTER_PORT=536
export SGE_ROOT=/opt/gridengine

function missingArgs {
   echo "Please specify mode:"
   echo "         -q => queue status"
   echo "         -j => job status"
   echo "         -n => node status"
   exit 3
}

function queueStatus {

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

   # --Calculate available cores
   aCoreCount=$(($qCoreCount-$rCoreCount))

   # --Count cores in demand
   #qwCores=($(qstat -s p|sed '1,2d'|tr -s '[:blank:]' ";"|cut -d ";" -f 9))
   qwCores=($(qstat -s p|sed '1,2d'|awk '{print $NF}'))
   qwCoreCount=0
   j=0

   while [ $j -lt ${#qwCores[*]} ];do
      qwCoreCount=$(($qwCoreCount + ${qwCores[$j]}))
      let j++
   done

   exitcode=0
   gridinfo="$rJobs jobs running on $rCoreCount cores. $qwJobs jobs waiting for $qwCoreCount cores. $aCoreCount cores available."

} # --queueStatus end

function nodeStatus {
   
   # --Count nodes by state
   tNodes=$(qstat -f -u none|grep all.q@compute|wc -l)		# Total nodes
   aNodes=$(qstat -f -qs a -u none|grep all.q@compute|wc -l)	# Alarm nodes
   dNodes=$(qstat -f -qs d -u none|grep all.q@compute|wc -l)	# Disabled nodes
   uNodes=$(qstat -f -qs u -u none|grep all.q@compute|wc -l)	# Unknown nodes
   ENodes=$(qstat -f -qs E -u none|grep all.q@compute|wc -l)	# Error nodes
   eNodes=$(( $tNodes-$dNodes ))				# Enabled nodes

   # --Check nodes by state and set exitcode/output accordingly
   if (( $aNodes > 0 ));then
      qErrors=$(qstat -u none -qs a -explain a|grep -A1 all.q@compute|grep -v ^"--"$|grep -v all.q@compute|tr -s '[:blank:]' " "|sort|uniq|tr -s "\n" "\!")
      for node in $(qstat -f -u none -qs a|grep all.q@compute|cut -d " " -f1|cut -d "." -f2|cut -d "@" -f2);do
         if [ -z "$qErrorNodes" ];then
            qErrorNodes=$node
         else
            qErrorNodes+=", $node"
         fi
      done
      exitcode=1
      gridinfo="$aNodes nodes in (a)larm state - $qErrorNodes: $qErrors"
   elif (( $ENodes > 0 ));then
      qErrors=$(qstat -u none -qs E -explain E|grep -A1 all.q@compute|grep -v ^"--"$|grep -v all.q@compute|tr -s '[:blank:]' " "|sort|uniq|tr -s "\n" "\!")
      for node in $(qstat -f -u none -qs E|grep all.q@compute|cut -d " " -f1|cut -d "." -f2|cut -d "@" -f2);do
         if [ -z "$qErrorNodes" ];then
            qErrorNodes=$node
         else
            qErrorNodes+=", $node"
         fi
      done
      exitcode=1
      gridinfo="$ENodes nodes in (E)rror state - $qErrorNodes: $qErrors"
   elif (( $uNodes > 0 ));then
      exitcode=1
      gridinfo="$uNodes nodes in (u)nknown state. If this status message is seen, it should be expanded to show node- and errorinfo like the a state does."
   else
      exitcode=0
      gridinfo="$eNodes nodes enabled, $dNodes nodes disabled."
   fi

} # --nodeStatus end

function jobStatus {
   
   # --Get total number of jobs in (E)rror state
   eJobCount=$(qstat|sed '1,2d'|tr -s '[:blank:]' " "|cut -d " " -f6|grep E|wc -l)
   
   # --Get total number of jobs stuck in (d)eleting state
   dJobCount=$(qstat|sed '1,2d'|tr -s '[:blank:]' " "|cut -d " " -f6|grep d|wc -l)

   # --Check jobs by state and set exitcode/output accordingly
   exitcode=0 #default exit code - altered by any positive if-test
   
   # ---Report jobs with errors
   if (( $eJobCount > 0  ));then
      for jobid in $(qstat|sed '1,2d'|tr -s '[:blank:]' " "|cut -d " " -f2,6|grep E|cut -d " " -f1);do
         if [ -z "$eJobIds" ];then
            eJobIds=$jobid
         else
            eJobIds+=", $jobid"
         fi
      done 
      exitcode=1
      gridinfo="$eJobCount job(s) with errors: $eJobIds."
   fi
   
   # ---Report jobs in (d)eleting state
   if (( $dJobCount > 0  ));then
      for jobid in $(qstat|sed '1,2d'|tr -s '[:blank:]' " "|cut -d " " -f2,6|grep d|cut -d " " -f1);do
         if [ -z "$dJobIds" ];then
            dJobIds=$jobid
         else
            dJobIds+=", $jobid"
         fi
      done 
      if [ -z "$gridinfo" ];then
         gridinfo="$dJobCount job(s) in (d)eleting state: $dJobIds."
      else
         gridinfo+=" $dJobCount job(s) in (d)eleting state: $dJobIds."
      fi
      exitcode=1
   fi
   
   # ---Get/report stuck jobs
   thisDay=$(date +%d|sed 's/^0//')
   thisMonth=$(date +%m|sed 's/^0//')
   #thisYear=$(date +%Y)
   sJobCount=0
   sJobTreshold=3 #days

   #jobarr=$(qstat -s r|sed '1,2d'|awk '{print $1,$6}'|tr -s " " "+")
   jobarr=$(qstat -s r|sed '1,2d'|awk '{print $1,$((NF-3))}'|tr -s " " "+")
   #example array data: 2327+08/11/2009

   for j in $jobarr;do
      jobid=$(echo $j|cut -d "+" -f1)
      startDay=$(echo $j|cut -d "+" -f2|cut -d "/" -f2|sed 's/^0//')
      startMonth=$(echo $j|cut -d "+" -f2|cut -d "/" -f1|sed 's/^0//')
      #startYear=$(echo $j|cut -d "+" -f2|cut -d "/" -f3)

      if (( $thisDay-$startDay > $sJobTreshold ));then
         if [ -z "$sJobIds" ];then
            sJobIds=$jobid
         else
            sJobIds+=", $jobid"
         fi
         let sJobCount++
      fi

      if (( $startMonth != $thisMonth ));then
         case "$startMonth" in
            02)
               startMonthDays="28"
               ;;
            04|06|09|11)
               startMonthDays="30"
               ;;
            *)
               startMonthDays="31"
               ;;
         esac

         if (( $startMonthDays-$startDay+$thisDay > $sJobTreshold ));then
            if [ -z "$sJobIds" ];then
               sJobIds=$jobid
            else
               sJobIds+=", $jobid"
            fi
            let sJobCount++
         fi
      fi

   done
   
   if (( $sJobCount > 0 ));then
      if [ -z "$gridinfo" ];then
         gridinfo="$sJobCount job(s) has been running for more than $sJobTreshold days: $sJobIds."
      else
         gridinfo+=" $sJobCount job(s) has been running for more than $sJobTreshold days: $sJobIds."
      fi
      exitcode=1
   fi

   # ---Set friendly status text if no error conditions were met
   if (( $exitcode == 0 ));then
      gridinfo="No jobs in (E)rror or (d)elete state. No jobs with compute time > $sJobTreshold days."
   fi

} # --jobStatus end

# Inspect input to determine which check to run
if (( $# > 0 ));then
   case "$1" in
      -q)
         queueStatus
         ;;
      -n)
         nodeStatus
         ;;
      -j)
         jobStatus
         ;;
      *)
         missingArgs
   esac
else
   missingArgs
fi

case "$exitcode" in
   0)
      exitstatus="OK"
      ;;
   1)
      exitstatus="Warning"
      ;;
   2)
      exitstatus="Critical"
      ;;
   *)
      exitstatus="Unknown"
      ;;
esac

# --Output section
echo "$exitstatus - $gridinfo"
exit $exitcode
