#!/bin/bash

# ----------------------------------------------------- #
# check_edac.sh by torad      last modified: 28.10.2009	#
# ----------------------------------------------------- #
# Purpose:						#
# - Check for any reported EDAC problems		#
# -- ce_count = correctable (single-bit) error count	#
# -- ue_count = uncorrectable (multi-bit) error count	#	
# ----------------------------------------------------- #

edacpath=/sys/devices/system/edac

# Quit if EDAC support is not present / not loaded
[ ! -d $edacpath ] && echo "EDAC support not present or not loaded." && exit 3

edacssr=$(cat /sys/devices/system/edac/mc/mc0/seconds_since_reset)

# Select time unit / calculate time value
if (( $edacssr < 3600 ));then 
   timeunit="minutes"
   timeval=$(($edacssr/60))
elif (( $edacssr < 86400 ));then 
   timeunit="hours"
   timeval=$(($edacssr/3600))
else					
   timeunit="days"
   timeval=$(($edacssr/86400))
fi

edacinfo="Last $timeval $timeunit:"
exitcode=0

for mc in $(ls $edacpath/mc/|grep mc[0-9]);do
   cecount=$(cat $edacpath/mc/$mc/ce_count)
   uecount=$(cat $edacpath/mc/$mc/ue_count)
   (( $cecount > 0 )) && exitcode=1
   (( $uecount > 0 )) && exitcode=2
   edacinfo+=" $mc: ce=$cecount, ue=$uecount"
done

case $exitcode in
   0)
      exitstatus="OK"
      ;;
   1)
      exitstatus="WARNING"
      ;;
   2)
      exitstatus="CRITICAL"
      ;;
   *)
      exitstatus="UNKNOWN"
      ;;
esac

echo "$exitstatus - $edacinfo"
exit $exitcode
