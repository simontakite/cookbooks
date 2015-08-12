#!/bin/bash

# --------------------------------------------------------------------- #
# coredumpsearch.sh by torad						#
# --------------------------------------------------------------------- #
# Created:	December 2009						#
# Changed:	05.11.2010						#
# Type:		Cron - monitoring / maintenance				#
# --------------------------------------------------------------------- #
# Purpose: 								#
# - Look for new core dump files					#
# - Notify $recipient about any new dump files written by ecore		#
# - Remove core dump files not written by ecore				#
# - Remove core dump files older than 7 days				#
# Usage:	 							#
# - Run as a cron job							#
# Prerequisites:							#
# - Computers configured to write core dumps to the monitored directory	#
# --------------------------------------------------------------------- #

recipient="-c it-alerts@numericalrocks.com kristian@numericalrocks.com"
dump_path=/san/temp/coredump
search=$dump_path/search.txt
ecoredumps=$dump_path/ecoredumps.txt
last=$dump_path/last.txt
new=$dump_path/new.txt

# Find all core dump files in /var/dump, write to searchlog
find $dump_path -iname core.* -exec ls -lh {} \; > $search

# Classify dumps by origin - remove non-ecore dumps, log and chmod ecore dumps
while read l;do 
   f=$(echo $l|awk {'print $9'})
   origin=$(file $f|awk {'print $14'})
   if [[ "$origin" == \'ecore\' ]] || [[ "$origin" == \'ecore_d\' ]];then
      echo $l >> $ecoredumps
      chmod 660 $f
   else
      rm $f
   fi
done < $search

# Check log from previous search to determine status of the individual core dump files (new / existing)
while read l; do
   f=$(echo $l|awk {'print $9'})
   if (( $(cat $last|grep $f|wc -l|awk {'print $1'}) == 0 ));then
      echo $l >> $new
   fi
done < $ecoredumps

# Send notification if any new dumps were found 
if [ -f $new ]; then
   new_count=$(wc -l $new|awk {'print $1'})
   echo >> $new
   echo "Disk usage:" >> $new
   echo >> $new
   df -h /san/temp >> $new
   cat $new | mail -s "$new_count new core dumps found in /net/temp/coredump" $recipient
fi

# Use the current search log as the reference for in next search
if [ -f $ecoredumps ];then
   mv $ecoredumps $last
fi

# Remove dumps older than 7 days from disk and search log
for f in $(find /san/temp/coredump -name "core*" -mtime +7);do
   rm $f
   sed -i '/$f/d' $last
done

# Clean up
rm $search
if [ -f $new ];then
   rm $new
fi
