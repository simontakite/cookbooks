#!/bin/bash

# ----------------------------------------------------- #
# check_msa_health.sh by torad 	last edit: 10.03.2010	#
# ----------------------------------------------------- #
# Purpose:						#
# - Use hpacucli to check MSA controller status		#
# Prerequisites:					#
# - Functional MSA, hpacucli, sudo access for nagios	#
# ----------------------------------------------------- #

#Name of the MSA chassis
#ch="SANdisk1"
ch=$1

#Path to hpacucli
hpacucli=/usr/sbin/hpacucli

#Temporary status file location
tempfile=/tmp/msa_health.out

#Generate the temporary status file
sudo $hpacucli ctrl ch=$ch show status > $tempfile

#controller_status=$(cat $tempfile|grep Controller|awk '{print $3}')
#cache_status=$(cat $tempfile|grep Cache|awk '{print $3}')
#battery_status=$(cat $tempfile|grep Battery|awk '{print $3}')
controller_status=$(cat $tempfile|grep Controller|cut -d ':' -f2|sed 's/\ //')
cache_status=$(cat $tempfile|grep Cache|cut -d ':' -f2|sed 's/\ //')
battery_status=$(cat $tempfile|grep Battery|cut -d ':' -f2|sed 's/\ //')

rm $tempfile

info="Controller Status: $controller_status, Cache Status: $cache_status, Battery Status: $battery_status"

if [[ "$controller_status" == "OMG" ]] || [[ "$cache_status" == "OMG" ]] || [[ "$battery_status" == "OMG"  ]];then
   exitcode=2
   exitstatus="CRITICAL"
elif [[ "$controller_status" == "WTF" ]] || [[ "$cache_status" == "Temporarily Disabled" ]] || [[ "$battery_status" == "WTF"  ]];then
   exitcode=1
   exitstatus="WARNING"
elif [[ "$controller_status" == "OK" ]] && [[ "$cache_status" == "OK" ]] && [[ "$battery_status" == "OK"  ]];then
   exitcode=0
   exitstatus="OK"
else
   exitcode=3
   exitstatus="UNKNOWN"
fi

echo "$exitstatus - $info."
exit $exitcode
