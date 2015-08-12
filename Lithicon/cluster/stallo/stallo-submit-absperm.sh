#!/bin/bash

# --------------------------------------------- #
# 	stallo-submit-absperm.sh by torad	#
# --------------------------------------------- #
# Purpose:					#
#  - Copy data set to stallo under Ståle's user	#
#  - Submit absolute permeability job		#
# --------------------------------------------- #

qsub=/opt/torque/bin/qsub # Stallo qsub path

if [ -z $1 ];then
   echo "You must specify number of nodes you want to run on. Each node has 8 cores. To run on 40 CPUs you would type:"
   echo " stallo-submit-absperm.sh 5"
   exit 1
fi

# Get user data
nodes=$1
user=$(whoami)
datapath=$(pwd)
datadir=$(basename $datapath)
submit="cd /global/work/steel/$datadir;$qsub -lnodes=$nodes:ppn=8 -M $user@numericalrocks.com /home/steel/runscript-absperm.sh"

# Display confirmation prompt for the pending tasks
#echo "Pending tasks:"
#echo "-> copy \"$datadir\" to Stallo" 
#echo "-> submit absolute permeability job to run on $nodes nodes"
#echo "-> Notification will be sent to $user@numericalrocks.com"
#read -p "Proceed? (y/n): " proceed

#if [ $proceed == "y" ];then
   scp -r $datapath steel@stallo.uit.no:/global/work/steel/
   ssh steel@stallo.uit.no $submit
#else
#   echo "Exiting on user request."
#   exit 2
#fi

