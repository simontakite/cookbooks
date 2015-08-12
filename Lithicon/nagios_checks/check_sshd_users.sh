#!/bin/bash

# ----------------------------------------------------- #
# check_sshd_users.sh by torad	  last edit: 16.10.2009	#
# ----------------------------------------------------- #
# Do:							#
# - List users currently logged in through ssh/sftp	#
# ----------------------------------------------------- #

sshdusers=$(ps -ef|grep sshd:|grep -e grep -e root -v|awk {'print $1'}|sort|uniq)
out=""
count=0

for u in $sshdusers;do
   let count++
   (( $count == 1 )) && out+="$u" || out+=", $u"
done

(( $count == 0 )) && sshdstatus="No active sshd users." || sshdstatus="$count active sshd users: $out."

echo $sshdstatus
exit 0
