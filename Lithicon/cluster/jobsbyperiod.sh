#!/bin/bash


if [ "$1" = "" ]; then
	echo "Usage: ./jobsbyperiod <begintime (YYYYMMddmmss)> <days (x)>"
else
	if [ "$2" = "" ]; then
		echo "Usage: ./jobsbyperiod <begintime (YYYYMMddmmss)> <days (x)>"
	else
		JOBS=`qacct -j -b $1 -d $2 | grep jobnumber | uniq | wc -l`
		echo "Number of jobs run: $JOBS."
	fi
fi
