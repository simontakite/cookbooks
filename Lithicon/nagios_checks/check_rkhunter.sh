#!/bin/bash

# -------------------------------------------------------------- #
# Check the rkhunter return file for the last rkhunter exit code #
# Also check when the logs were last changed                     #
# -------------------------------------------------------------- #

oldlogs=0

thisYear=$(date +%Y)
thisMonth=$(date +%m)
thisDay=$(date +%d)

returnYear=$(stat /var/log/rkhunter-return.log|tail -n 1|cut -d " " -f2|cut -d "-" -f1)
returnMonth=$(stat /var/log/rkhunter-return.log|tail -n 1|cut -d " " -f2|cut -d "-" -f2)
returnDay=$(stat /var/log/rkhunter-return.log|tail -n 1|cut -d " " -f2|cut -d "-" -f3)

logYear=$(stat /var/log/rkhunter.log|tail -n 1|cut -d " " -f2|cut -d "-" -f1)
logMonth=$(stat /var/log/rkhunter.log|tail -n 1|cut -d " " -f2|cut -d "-" -f2)
logDay=$(stat /var/log/rkhunter.log|tail -n 1|cut -d " " -f2|cut -d "-" -f3)

if (( $returnYear != $thisYear )); then oldlogs=1; fi
if (( $returnMonth != $thisMonth )); then oldlogs=1; fi
if (( $returnDay+1 < $thisDay )); then oldlogs=1; fi
if (( $logYear != $thisYear )); then oldlogs=1; fi
if (( $logMonth != $thisMonth )); then oldlogs=1; fi
if (( $logDay+1 < $thisDay )); then oldlogs=1; fi

if (( oldlogs == 1 )); then
   echo "Warning - rkhunter cron has not run since $returnDay.$returnMonth.$returnYear"
   exit 1
else
   rkhstatus=$(cat /var/log/rkhunter-return.log)
   if (( $rkhstatus == 0 )); then
      echo "OK - No threats detected."
   else
      echo "Problem: rkhunter last exited with status $rkhstatus"
   fi
   exit $rkhstatus
fi
