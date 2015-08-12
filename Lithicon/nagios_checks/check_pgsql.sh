#!/bin/bash
# ----------------------------------------------------- #
# check_pgsql.sh by torad                               #
# ----------------------------------------------------- #
# Created:      23.04.2010                              #
# Changed:      14.12.2010                              #
# Type:         nagios - information                    #
# ----------------------------------------------------- #
# Purpose:                                              #
# - Show computers connected to the pgsql server	#
# ----------------------------------------------------- #

#connected=$(ps ax|grep epdb|grep -v grep|awk {'print $8'}|sed 's/([0-9]*)//g'|sort|uniq)
pgport=5432
connected=$(netstat -t --numeric-ports|grep $pgport|awk {'print $5'}|cut -d "." -f1|sort|uniq)
num_connected=$(echo $connected|wc -w)

if (( $num_connected == 0 ));then
   info="No connections."
else
   #for ip in $(echo $connected);do
   #   hostname=$(host $ip|awk {'print $5'}|cut -d '.' -f1)
   #   [ -z "$dns_connected" ] && dns_connected="$hostname" || dns_connected+=", $hostname"
   #done
   info="$num_connected computer(s) connected: $connected"
fi

echo $info
