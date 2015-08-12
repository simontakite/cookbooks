#!/bin/bash
# -----------------------------------------------------	#
# guestsubmit.sh by torad				#
# -----------------------------------------------------	#
# Created:	10.11.2010				#
# Changed:	19.11.2010				#
# Type:		Cluster - utility			#
# ----------------------------------------------------- #
# Purpose:						#
# - Facilitate submission of cluster jobs from 		#
#   computers without direct access to the cluster	#
# Usage:						#
# - ./guestsubmit.sh <options>				#
# Prerequisites:					#
# - Cron job on the cluster frontend that searches for	#
#   .submitme files and submits them according to spec	#
# ----------------------------------------------------- #

# Disallow submission if the job was already submitted

[ -f STARTED ] && echo "This job has already been submitted and is running." && exit 2
[ -f .queued ] && echo "This job has already been submitted and is queued." && exit 3

# Functions and defaults

jobtypes="abs ff rwff nmr"
versions="1.1 1.2.1 1.3.3 1.4.4"
job_valid=0
ver_valid=0

function usage {
   echo "Error: $errtxt"
   echo ""
   echo "Usage: $(basename $0) -c <number of cpus> -t <job type> -v <e-Core version>"
   echo "- valid job types       :   abs ff rwff (=> 1.4.4) nmr (=> 1.2.1)"
   echo "- valid e-Core versions :   $versions"
   echo ""
   exit 1
}

function isnumeric {
   case $1 in
      ''|*[!0-9]*) return 1;;
      *) return 0;;
   esac
}

# Parse input

while getopts ":t:v:c:" options;do
   case $options in
      t) jobtype=$OPTARG;;
      v) version=$OPTARG;;
      c) cpus=$OPTARG;;
      :) echo "value not specified for option: -$OPTARG";;
      *) echo "Invalid option.";usage;;
   esac
done

if [ -z $jobtype ]; then
   errtxt="Job type not specified.";usage
else
   for jtyp in $jobtypes;do
      if [[ $jobtype == $jtyp ]];then
         job_valid=1
      fi
   done
   if (( $job_valid != 1 )); then
      errtxt="Invalid job type";usage
   fi
fi

if [ -z $version ]; then
   errtxt="Version not specified.";usage
else
   for v in $versions;do
      if [[ $version == $v ]];then
         ver_valid=1
      fi
   done
   if (( $ver_valid != 1 ));then
      errtxt="Invalid version";usage
   fi
fi

if [ -z $cpus ]; then
   errtxt="Number of CPUs not specified.";usage
else
   if ! $(isnumeric $cpus); then
      errtxt="Not a numeric value: $cpus";usage
   fi
fi

if [[ $jobtype == "rwff" ]] && [[ $version != 1.4.4 ]];then
   errtxt="rwff only supported in version 1.4.4 and later.";usage
fi

if [[ $jobtype == "nmr" ]] && [[ $version == 1.1 ]];then
   errtxt="nmr not supported in version 1.1.";usage
fi

# Create the submit specification

(
echo Submitted at $(date "+%d.%m.%Y %H:%M")
echo run=$jobtype
echo version=$version
echo cpus=$cpus
) > .submitme
