#!/bin/bash
NUM_UPDATES=$(yum check-update -q|wc -l)

if (( "$NUM_UPDATES" > 0 )); then
	let "NUM_UPDATES-=1"
fi

if (( "$NUM_UPDATES" > 2 )); then
	echo "Warning - $NUM_UPDATES updates available!"
	exit 1
else
	echo "OK - $NUM_UPDATES updates available."
	exit 0
fi
