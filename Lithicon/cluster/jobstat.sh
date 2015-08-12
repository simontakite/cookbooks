#!/bin/bash

# ----------------------------------------------------- #
# jobstat.sh by torad					#
# ----------------------------------------------------- #
# Created:	2009					#
# Changed:	11.06.2010				#
# Type:		Administration utility / alias target	#
# ----------------------------------------------------- #
# Purpose:						#
# - Display stdout and stderr for the selected		#
#   sge job(s)						#
# Required input:					#
# - One selection option and zero or one output option	#
# ----------------------------------------------------- #

function usage {
   echo $errtxt
   echo "Usage: $(basename $0) [-o|-e] -a|-u [<user>]|-j <jobid> [<jobid>] ... [<jobid>]"
   echo "   -a : 	select all running jobs"
   echo "   -u : 	select all running jobs owned by <user> (default: $(whoami))"
   echo "   -j : 	select job(s) by job id(s)"
   echo "   -o : 	show stdout only (default: both)"
   echo "   -e : 	show stderr only (default: both)"
   exit 1
}

# Show usage and quit if nothing was specified
if (( $# == 0 ));then errtxt="Error: nothing specified";usage;fi

debug=0
jobargs=0
alljobs=0
userjobs=0
somejobs=0
user=""
outargs=0
showerr=1
showout=1

while getopts ":adeou:j" options;do
   case $options in
      a) alljobs=1; let jobargs++;;
      u) 
         userjobs=1 
         let jobargs++
         user=$OPTARG
         ;;
      j) somejobs=1; let jobargs++;;
      e) showout=0; let outargs++;;
      o) showerr=0; let outargs++;;
      d) debug=1;;
      :) 						# If an option that requires an argument misses the argument, 
         if [ $OPTARG == "u" ];then			#+ the colon sign is put inside the $options variable,
            userjobs=1					#+ and the option character (which is missing its argument)
            let jobargs++				#+ inside the $OPTARG variable.
            user=$(whoami)
         fi
         ;;
      *) errtxt="Error: Invalid or missing option or argument";usage;;
   esac
done

if (( $debug == 1 )); then echo "Jobargs=$jobargs";fi

# Remaining script argument (non-options) will be accessible from $1:
shift $(($OPTIND-1))

# Show usage and quit if more than one job selection option was specified
if (( $jobargs > 1 ));then 
   errtxt="Error: You cannot specify more than one job selection option."
   usage
fi
# Show usage and quit if more than one output selection option was specified
if (( $outargs > 1 ));then 
   errtxt="Error: You cannot specify more than one output option."
   usage
fi
# Show usage and quit if no job selection option was specified
if (( $jobargs == 0 ));then
   errtxt="Error: Job selection option not specified"
   usage
fi
# Show usage and quit if job id(s) were needed but not specified
if (( $somejobs == 1 )) && (( $# == 0 ));then
   errtxt="Error: No job id(s) supplied"
   usage
fi

if (( $alljobs == 1 ));then
   joblist=$(qstat -s r|sed 1,2d|awk {'print $1'})
elif (( $userjobs == 1 ));then
   joblist=$(qstat -s r|sed 1,2d|grep $user|awk {'print $1'})
   if [ "$joblist" == "" ];then
      echo "Error: User $user has no running jobs."
      exit 2
   fi
elif (( $somejobs == 1 ));then
   if (( $debug == 1 ));then echo "\$@ is: $@";fi
   joblist=$@
   for job in $joblist;do   
      qstat -j $job > /dev/null
      err=$?
      if (( $err != 0  ));then
         exit 3
      fi
   done
fi

# Display stdout and stderr for the job(s):
for jobid in $joblist;do
   jobdir=$(qstat -j $jobid|grep cwd|awk {'print $2'})
   jobname=$(qstat -j $jobid|grep job_name|awk {'print $2'})
   stdout=$jobdir/$jobname*.o$jobid
   stderr=$jobdir/$jobname*.e$jobid
   if (( $showout == 1 ));then less $stdout;fi
   if (( $showerr == 1 ));then less $stderr;fi
done

exit 0
