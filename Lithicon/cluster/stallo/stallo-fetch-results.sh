#!/bin/bash

# --------------------------------------------- #
#       stallo-fetch-results.sh by torad	#
# --------------------------------------------- #
# Purpose:                                      #
#  - Get results from absolute permeability job #
#  - Delete the data from Stallo		#
# --------------------------------------------- #

# Get user data
datapath=$(pwd)
datadir=$(basename $datapath)

# Display confirmation prompt for the pending tasks
echo "Pending tasks:"
echo "-> copy *.out from Stallo to $datadir" 
echo "-> delete $datadir from Stallo"
read -p "Proceed? (y/n): " proceed

if [ $proceed == "y" ];then
   scp -r steel@stallo.uit.no:/global/work/steel/$datadir/*.o* $datapath
   touch STARTED
   touch STOPPED
   echo "Job was run on Stallo" > STOPPED
   ssh steel@stallo.uit.no rm -r /global/work/steel/$datadir
else
   echo "Exiting on user request."
   exit 2
fi
