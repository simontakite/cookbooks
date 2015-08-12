#!/bin/bash

# calculate $soft to 90% of $1
#let soft=$1*9/10
#echo $soft

# Exactly one full backup job will run during the first 7 days of any month.
#+ By dividing the day-of-month by 8, we'll get a 0 for the first full backup of the month,
#+ which normally serves as the "monthly" backup job. We can use this when we
#+ want to do something right before/after a full monthly backup, i.e. compress and move
#+ postgresql transaction logs from /opt/pgsql/archive on Bogota to /san/archive/pgarchive on Santiago.
#+ The script can be triggered from the backup job in Data Protector, and stdout will
#+ be written to the backup job log.

let weekly=$(date +%d)/8
if (( $weekly == 0 ));then
   echo "This is the monthly full."
fi

lm=$(date -d "last month" +%B)
echo "Last month was $lm."
