#!/bin/bash

# ----------------------------------------------------- #
# check_quota.sh by torad    last modified: 12.04.2010 	#
# ----------------------------------------------------- #
# Purpose:						#
# - Check quota usage					#
# Required input:					#
# - Mount point						#
# Relies on:						#
# - sudo rights for nagios to execute this script	#
# ----------------------------------------------------- #

# Verify that we received input
if (( $# < 1  )); then
   info="Mount point not specified"
   exitcode=3

else
   mountpoint=$1
   mounts=$(cat /proc/mounts|awk '{print $2}')
   # Get current mounts
   for m in $mounts;do 
      [[ $m == $mountpoint ]] && mp_exist=1
   done
   
   # Verify input
   if [ -z $mp_exist ];then
      info="Mount point $mountpoint does not exist"
      exitcode=3
   else
      
      # Input verified - Check quota usage
      temp=/tmp/check_quota_temp.txt
      /usr/sbin/repquota /ftp|sed '1,5d'|grep -v ^$ > $temp
      q_reached_count=0
      while read l;do
         q_user=$(echo $l|awk '{print $1}')
         q_used=$(echo $l|awk '{print $3}')
         q_soft=$(echo $l|awk '{print $4}')
         # Ignore users with quota = 0 (unlimited)
         if (( $q_soft  > 0 ));then
            if (( $q_used >= $q_soft ));then
               # Populate the list of users with exceeded soft limits
               if [ -z "$q_reached_users" ];then
                  q_reached_users=$q_user
               else
                  q_reached_users+=", $q_user"
               fi
               let q_reached_count++
            fi
         fi
      done < $temp
      rm $temp

      # Determine status by evaluating $q_reached_count
      if (( $q_reached_count > 0 ));then
         (( $q_reached_count == 1 )) && user_or_users="user" || user_or_users="users"
         info="$q_reached_count $user_or_users have reached the soft limit: $q_reached_users"
         exitcode=1
      elif (( $q_reached_count == 0 ));then
         info="No users have reached their soft limit"
         exitcode=0
      else
         info="q_reached_count is causing unexpected behaviour - investigate"
         exitcode=3
      fi
   fi
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
echo "$exitstatus - $info."
exit $exitcode
