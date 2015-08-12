#!/bin/bash

# ----------------------------------------------------- #
# check_mpt_raid.sh by torad                            #
# ----------------------------------------------------- #
# Do:                                                   #
# - Check raid status 				        #
# Relies on:						#
# - /usr/sbin/mpt-status (RPM package available)	#
# - module mptctl loaded into kernel			#
# - sudo rights for nagios to execute this script	#
# ----------------------------------------------------- #

# Make sure the mptctl module is loaded
mptctl=$(/sbin/lsmod|grep mptctl|wc -l)
if [[ "$mptctl" == 0  ]]; then
   exitstatus="UNKNOWN"
   exitcode=3
   raidinfo=" module mptctl not loaded"
else
   raidinfo=$(sudo /usr/sbin/mpt-status|head -n1|cut -d "," -f4,5)
   raidstatus=$(sudo /usr/sbin/mpt-status|head -n1|cut -d "," -f4|cut -d " " -f3)

   if [[ "$raidstatus" == "OPTIMAL" ]]; then
      exitcode=0
      exitstatus="OK"
   elif [[ "$raidstatus" == "DEGRADED" ]]; then
      exitcode=1
      exitstatus="WARNING"
   elif [[ "$raidstatus" == "FAILED" ]]; then
      exitcode=2
      exitstatus="CRITICAL"
   else  
      exitcode=3
      exitstatus="UNKNOWN"
   fi
fi

echo "$exitstatus -$raidinfo."
exit $exitcode
