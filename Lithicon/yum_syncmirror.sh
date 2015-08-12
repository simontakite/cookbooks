#!/bin/bash

# --------------------------------------------- #
# yum_syncmirror.sh by torad			#
#  --------------------------------------------	#
# Created:      06.09.2010 	 		#
# Changed:				 	#
# Type:         Cron				#
# --------------------------------------------- #
# Purpose:                                      #
# - Synchronise local yum repo with upstream	#
# Usage:                                        #
# - Run as a cron job                           #
# --------------------------------------------- #

logfile="/var/log/yum_syncmirror.log"
c5updates=""
c4updates=""
c5base=""

( 
        echo "*** CentOS 5 x86_64 - Updates ***"
	echo
	cd /var/www/html/centos/5/updates 
        rsync -harv --stats --delete-after ftp.uninett.no::centos/5/updates/x86_64 .
	c5updates=$(echo $?)

        echo
	echo "*** CentOS 4 x86_64 - Updates ***"
	echo
	cd /var/www/html/centos/4/updates
        rsync -arhv --stats --delete-after ftp.uninett.no::centos/4/updates/x86_64 .
	c4updates=$(echo $?)
 
	echo
        echo "*** CentOS 5 x86_64 - Base ***"
	echo
        cd /var/www/html/centos/5/os 
        rsync -havr --stats --delete-after ftp.uninett.no::centos/5/os/x86_64 .
	c5base=$(echo $?)

	echo
	echo "***** STATS *****"
	echo
	echo "c5updates = $c5updates"
	echo "c4updates = $c4updates"
	echo "c5base = $c5base"
	echo "rundate = $(date +%s)"
) &> $logfile

chown -R apache:apache /var/www/html/centos
