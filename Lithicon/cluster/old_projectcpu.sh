#!/bin/bash

# -- Only display help if that's what's asked for --

if [ "$1" == "--help" ]; then
	echo "--> projectcpu.sh by torad <--"
	echo ""
	echo "Purpose:"
	echo "- Display cluster resource usage, per project"
	echo ""
	echo "Usage:"
	echo "- invoke projectcpu.sh without arguments to specify 'all time'."
	echo "- invoke projectcpu.sh [num] to display resource usage starting [num] days ago, up until today."
	echo "- invoke projectcpu.sh with any other arguments to receive an error message storm." 
	echo ""
else


	# --- Set variables, create account array ---

	DAYS="-d $1"
	OST=(`qacct -j | grep account | sort | uniq | sed 's/account\s*//' | tr '\n' ' '`)

	# --- Output time scope ---

	if [ "$1" != "" ]; then
		OUT="Cluster usage per account for the last $1 days:"
	else
		OUT="Cluster usage per account for all time:"
	fi

	echo $OUT

	# --- Loop through account array and output total resources used for the specified time scope --- 

	len=${#OST[*]}
	i=0
	while [ $i -lt $len ]; do

		# --- Check whether any jobs has run on the individual project in the given time frame. If not, don't output that project. ---

		if [ "$1" != "" ]; then	
			ROWS=`qacct -A ${OST[$i]} $DAYS | wc -l`
		else
			ROWS=`qacct -A ${OST[$i]} | wc -l`
		fi
	
		if [ $ROWS -gt 3 ]; then

			echo "Account: ${OST[$i]}"
			echo "========================================="

			if [ "$1" != "" ]; then	
				qacct -A ${OST[$i]} $DAYS | grep -v "Total"
			else
				qacct -A ${OST[$i]} | grep -v "Total"
			fi

			echo ""
			echo ""
		fi
		let i++
	done

fi
