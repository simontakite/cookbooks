#!/bin/bash
# --------------------------------------------- #
# pgbackup.sh by torad	  last edit: 03.05.2010	#
# --------------------------------------------- # --------------------- #
# PostgreSQL integration control script for HP Data Protector		#
# Purpose:								#
# - Initiate PostgreSQL-related backup tasks from Data Protector	#
# - Make sure pgarchive is not backed up until pgdata backup is done	#
# --------------------------------------------------------------------- #

echo "$(date +%H:%M): Begin $1"

case $1 in
   pgdata_start)
   	psql -U backup -c "SELECT pg_start_backup('epdb-$(date +%Y%m%d)');" postgres
   	;;
   pgdata_stop)
   	psql -U backup -c "SELECT pg_stop_backup();" postgres
	;;
   pgarchive_stop)
	# Determine whether this is a "monthly full" job. The job classified as the "monthly full" is the
	#+ first full job started between the first Friday of the month (inclusive) and the second Friday 
	#+ of the month (exclusive).
	day_n=$(date +%a)
	if [[ "$day_n" == "Fri" ]];then
           day=$(date +%d|sed 's/^0//')
	else
	   day=$(date -d "last friday" +%d|sed 's/^0//')
	fi
        let weekly=$day/8	# Returns 0-3

	# Perform pgsql archive maintenance only if this is a "monthly" job
        if (( $weekly == 0 ));then
	   # Make sure /net/archive is mounted before proceeding
           ! grep -q "/net/archive" /proc/mounts && echo "/net/archive is not mounted - Aborting pgsql archive maintenance." && exit 1

           month=$(date -d "last month" +%m)
	   month_n=$(date -d "last month" +%B)
           year=$(date -d "last month" +%Y)
           search_path="/opt/pgsql/archive/*"
           tarball="/net/archive/pgarchive/pgarchive-$year-$month.tgz"
           temp1="/var/tmp/find.txt"
           temp2="/var/tmp/tar.txt"
           echo "*** This is the monthly full job of $month_n $year - Performing pgsql archive maintenance. ***"
	   
	   # Find all files owned by postgres (uid=26) inside /opt/pgsql/archive
	   echo "$(date +%H:%M): Finding transaction logs..."
           find $search_path -maxdepth 0 -uid 26 > $temp1
	   files=$(cat $temp1)

	   # Try to create the tarball
	   echo "$(date +%H:%M): Creating tarball..." 
           tar czf $tarball $files

	   # Verify tarball. Delete source files on success.
           if (( $? == 0 ));then
              echo "$(date +%H:%M): Verifying tarball..."
              tar tzf $tarball | sed 's/^opt/\/opt/' > $temp2
              diff -q $temp1 $temp2
              if (( $? == 0 ));then
                 echo "$(date +%H:%M): Tarball verification succeded. Performing pgsql archive purge..."
                 rm $files
                 echo "$(date +%H:%M): $(wc -l $temp2|awk {'print $1'}) transaction logs were processed."
              else
                 echo "$(date +%H:%M): Tarball verification failed. Skipping pgsql archive purge."
              fi
              rm $temp1 $temp2
           else
              echo "$(date +%H:%M): Failed to create $tarball. Skipping pgsql archive purge."
           fi
        else
           echo "*** This is a weekly full job - Skipping pgsql archive maintenance. ***"
        fi
        ;;
   *)
	echo "Usage: pgbackup.sh pgdata_start|pgdata_stop|pgarchive_stop"
	exit 1
esac
echo "$(date +%H:%M): End $1"
