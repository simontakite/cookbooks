#!/bin/bash
# ----------------------------------------------------- #
# check_clamav.sh by torad				#
# ----------------------------------------------------- #
# Created:	      2009				#
# Changed:	08.07.2010				#
# Type:		nagios - monitoring			#
# ----------------------------------------------------- #
# Purpose:						#
# - Check whether scans are running as expected		#
# - Check whether definitions are being updated		#
# - Check whether the virus scan engine is outdated	#
# - Check number of viruses found in the last scan	#
# ----------------------------------------------------- #

viruscount=0

cron_log="/var/log/clamav/cronscan.log"
cron_log_size=16
cron_log_cdate=$(stat $cron_log |grep -i change|cut -d " " -f2|sed 's/-//g')
cron_log_ctime=$(stat $cron_log |tail -n1|cut -d " " -f3|cut -d "." -f1)
cron_log_gid=$(ls -l $cron_log |cut -d " " -f4)
[ -f "/var/clamav/daily.cld" ] && daily="/var/clamav/daily.cld" || daily="/var/clamav/daily.cvd"
definitions_cdate=$(stat $daily |grep -i change|cut -d " " -f2|sed 's/-//g')
for l in $(tail -n $(($cron_log_size*2)) $cron_log|grep -i infected|cut -d " " -f3);do
   let viruscount+=$l
done

today=$(date +%Y%m%d)

freshclam_log="/var/log/clamav/freshclam.log"
freshclam_log_linecount=$(wc -l $freshclam_log|awk {'print $1'})
freshclam_log_lastlog_linenumber=$(grep -n '\-\-\-\-\-\-\-' $freshclam_log|sort -r|head -n1|cut -d ':' -f1)
freshclam_log_lastlog_contents=$(($freshclam_log_linecount - $freshclam_log_lastlog_linenumber))
outdated=$(tail -n $freshclam_log_lastlog_contents $freshclam_log|grep -c OUTDATED)

if (( $viruscount != 0 ));then
   exitstatus="CRITICAL"
   info="Infected files: $viruscount - See $cron_log"
   exitcode=2
elif (( $outdated > 0 ));then
   exitstatus="WARNING"
   info="Freshclam reports that the ClamAV engine is outdated"
   exitcode=1
elif (( "$definitions_cdate" +1 < "$today" ));then
   exitstatus="WARNING"
   info="Virus definitions not updated since $definitions_cdate"
   exitcode=1
elif (( "$cron_log_cdate" +1 < "$today" ));then
   exitstatus="WARNING"
   info="Last scan performed $cron_log_cdate at $cron_log_ctime"
   exitcode=1
elif [ "$cron_log_gid" != "nagios" ];then
   exitstatus="UNKNOWN"
   info="Unable to access scan log"
   exitcode=3
elif (( $viruscount == 0 )) && (( $outdated == 0 )) && (( "$definitions_cdate" +1 >= "$today" ));then
   exitstatus="OK"
   info="No viruses. Definitions and engine up to date"
   exitcode=0
else
   exitstatus="UNKNOWN"
   info="Investigation required"
   exitcode=3
fi

echo "$exitstatus - $info."
exit $exitcode
