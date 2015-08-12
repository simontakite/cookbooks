#!/bin/bash
#---------------------------------------------- #
# check_yum_msync.sh by torad			#
#---------------------------------------------- #
# Created:	06.09.2010			#
# Changed:	29.10.2010			#
# Type:		nagios - monitoring		#
# --------------------------------------------- #
# Purpose:					#
# - Check whether local yum mirror is being	#
#   properly synced				#
# Depends on:					#
# - /etc/cron.daily/yum_syncmirror.sh		#
# --------------------------------------------- #

TOLERANCE=1
LOGFILE="/var/log/yum_syncmirror.log"
TODAY=$(date +%s)
ERR_C5U=$(grep c5updates $LOGFILE | awk {'print $3'})
#ERR_C4U=$(grep c4updates $LOGFILE | awk {'print $3'})
ERR_C5B=$(grep c5base $LOGFILE | awk {'print $3'})
#ERR_SUM=$(($ERR_C5U + $ERR_C4U + $ERR_C5B))
ERR_SUM=$(($ERR_C5U + $ERR_C5B))
RUNDATE=$(grep rundate $LOGFILE | awk {'print $3'})
DAYS_OLD=$((($TODAY - $RUNDATE) / 86400))

if (( $DAYS_OLD > $TOLERANCE )); then
   exitcode=1
   info="Last sync $DAYS_OLD days ago"
else
   if (( $ERR_SUM == 0 ));then
      exitcode=0
      info="All local repos properly synchronised"
   #elif (( $ERR_C5U > 0  )) || (( $ERR_C4U > 0 )) || (( $ERR_C5B  > 0 )); then
   elif (( $ERR_C5U > 0  )) || (( $ERR_C5B  > 0 )); then
      exitcode=1
      #info="Synchronisation errors: C5U=exit $ERR_C5U, C5B=exit $ERR_C5B, C4U=exit $ERR_C4U"
      info="Synchronisation errors: C5U=exit $ERR_C5U, C5B=exit $ERR_C5B"
   else
      exitcode=3
      info="Investigate"
   fi
fi

case $exitcode in
   0)
      exitstatus="OK"
      ;;
   1)
      exitstatus="Warning"
      ;;
   2)
      exitstatus="Critical"
      ;;
   3)
      exitstatus="Unknown"
      ;;
esac

echo "$exitstatus - $info."
exit $exitcode
