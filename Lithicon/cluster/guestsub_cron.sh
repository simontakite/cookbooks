#!/bin/bash
# -----------------------------------------------------	#
# guestsub_cron.sh by torad				#
# -----------------------------------------------------	#
# Created:	19.11.2010				#
# Changed:						#
# Type:		Cluster - cron				#
# ----------------------------------------------------- #
# Purpose:						#
# - Search for .submitme files containing job spec	#
#   and submit jobs to the cluster accordingly		#
# Usage:						#
# - Run as a cron job without arguments			#
# ----------------------------------------------------- #

#Set SGE environment
export SGE_ROOT=/opt/gridengine
export SGE_QMASTER_PORT=536

#Set bash environment
export LD_LIBRARY_PATH=/opt/openmpi/lib:$LD_LIBRARY_PATH
export PATH=/opt/gridengine/bin/lx26-amd64:/opt/openmpi/bin:$PATH


search=$(find /net/temp/suhaib -name .submitme -exec dirname {} \;)
acct="IP-016"
prio="-1023"

for jobdir in $search;do
   cd $jobdir
   
   ver=$(grep version .submitme|cut -d "=" -f2)
   case $ver in
      1.1)
         abspath="/net/software/cluster/ecore-1.1/absperm-1.1.sh"
         ffpath="/net/software/cluster/ecore-1.1/formationfactor-1.1.sh"
         ;;
      1.2.1)
         abspath="/net/software/cluster/ecore-1.2.1/absperm-1.2.1.sh"
         ffpath="/net/software/cluster/ecore-1.2.1/formationfactor-1.2.1.sh"
         nmrpath="/net/software/cluster/ecore-1.2.1/nmr-1.2.1.sh"
         ;;
      1.3.3)
         abspath="/net/software/cluster/ecore-1.3.3/absperm-1.3.3.sh"
         ffpath="/net/software/cluster/ecore-1.3.3/formationfactor-1.3.3.sh"
         nmrpath="/net/software/cluster/ecore-1.3.3/nmr-1.3.3.sh"
         ;;
      1.4.4)
         abspath="/net/software/cluster/ecore-1.4.3/absperm-1.4.sh"
         ffpath="/net/software/cluster/ecore-1.4.3/formationfactor-1.4.sh"
         rwffpath="/net/software/cluster/ecore-1.4.3/rw_formationfactor-1.4.sh"
         nmrpath="/net/software/cluster/ecore-1.4.3/nmr-1.4.sh"
         ;;
   esac
   
   job=$(grep run .submitme|cut -d "=" -f2)
   case $job in
      abs) submitscript=$abspath;;
      ff) submitscript=$ffpath;;
      rwff) submitscript=$rwffpath;;
      nmr) submitscript=$nmrpath;;
   esac

   cpus=$(grep cpus .submitme|cut -d "=" -f2)

su suhaib -c "qsub -A $acct -pe orte $cpus -p $prio $submitscript &> .queued"
su suhaib -c "cat .submitme >> .queued"
su suhaib -c "rm .submitme"

done
