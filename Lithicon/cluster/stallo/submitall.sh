#!/bin/bash

for jobdir in $(ls -l|grep ^d|awk '{print $9}');do
   # Determine job type
   jobtype=$(echo $jobdir|cut -d '-' -f4)
   case $jobtype in
      absperm)
         sub="qsub -lwalltime=08:00:00 -lnodes=1:ppn=8 -N $jobdir -M tor@numericalrocks.com /home/steel/runscript-absperm.sh"
         ;;
      rwabsperm)
         sub="qsub -lwalltime=08:00:00 -lnodes=1:ppn=8 -N $jobdir -M tor@numericalrocks.com /home/steel/rwabsperm.sh"
         ;;
      rwff)
         sub="qsub -lwalltime=08:00:00 -lnodes=1:ppn=8 -N $jobdir -M tor@numericalrocks.com /home/steel/rwformationfactor.sh"
         ;;
   esac
   # Submit the job if jobdir has no .out files
   if (( $(ls -l $jobdir|grep -c .out) == 0 ));then
      cd $jobdir
      $sub
      cd ..
   fi
done
