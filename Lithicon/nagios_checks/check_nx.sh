#!/bin/bash

# --------------------------------------------- #
# check_nx.sh by torad    Last edit: 21.04.2010 #
# --------------------------------------------- #
# Purpose:                                      #
# - Display list of enabled and active NX users #
# Relies on:                                    #
# - nagios user: sudo rights on $0              #
# --------------------------------------------- #

nxserver=/usr/NX/bin/nxserver

for u in $($nxserver --userlist|grep -v ^NX|grep -v ^$|sed '1,2d');do
   if [ -z "$enabled_users" ];then
      if [ -z "$u" ]; then
         enabled_users="None"
      else
         enabled_users=$u
      fi
   else
      enabled_users+=", $u"
   fi
done

for u in $($nxserver --list|grep -v ^NX|grep -v ^$|sed '1,2d'|tr -s '[:blank:]' ',');do
   if [ -z "$active_users" ];then
      if [ -z "$u" ]; then
         active_users="None"
      else
         u_usr=$(echo $u|cut -d ',' -f2)
         u_ip=$(echo $u|cut -d ',' -f3)
         active_users="$u_usr from $u_ip"
      fi
   else
      u_usr=$(echo $u|cut -d ',' -f2)
      u_ip=$(echo $u|cut -d ',' -f3)
      active_users+=", $u_usr from $u_ip"
   fi
done

echo "Enabled users: $enabled_users *** Active users: $active_users"
