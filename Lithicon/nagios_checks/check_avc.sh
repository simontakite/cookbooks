#!/bin/bash
#---------------------------------------------- #
# check_avc.sh by torad				#
#---------------------------------------------- #
# Created:	10.08.2010			#
# Changed	10.08.2010			#
# Type:		nagios - monitoring		#
# --------------------------------------------- #
# Purpose:					#
# - Check whether any new AVC denials were	#
#   reported during the last week		#
# --------------------------------------------- #

DENIALS=$(/sbin/aureport -a --failed -ts $(date '+%m/%d/%Y %H:%M:%S' -d last-week) -te today|grep ^[0-9]|wc -l)
DENIALS_TOTAL=$(/sbin/aureport -a --failed|grep ^[0-9]|wc -l)

if (( "$DENIALS" > 0 )); then
   exitcode=1
   exitstatus="Warning"
elif (( $DENIALS == 0 )); then
   exitcode=0
   exitstatus="OK"
else
   exitcode=3
   exitstatus="Unknown"
fi

info="Last 7 days: $DENIALS AVC denials logged. ($DENIALS_TOTAL total)"

echo "$exitstatus - $info."
exit $exitcode
