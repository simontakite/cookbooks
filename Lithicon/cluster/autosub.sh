#!/bin/bash

# Loop recursively through a set directory and look for compute.cfg files.
# Check the np= and run= parameters inside
# Run qsub based on this

#Set SGE environment
export SGE_ROOT=/opt/gridengine
export SGE_QMASTER_PORT=536

#Set bash environment
export LD_LIBRARY_PATH=/opt/pathscale/lib/3.0:/opt/openmpi-1.2.3-pathscale-3.0/lib:$LD_LIBRARY_PATH
export PATH=/opt/gridengine/bin/lx26-amd64:/opt/openmpi-1.2.3-pathscale-3.0/bin:$PATH

#Start the autosub procedure
computefiles=`find /state/cluster-store/stud/ -name compute.cfg`

mc=24												#Max cores requestable
pn="1002"											#Project number

for cf in ${computefiles}
do
	dirname=`dirname $cf`									#Get the directory name
	log="$dirname/autosub.log"
	cd $dirname										#Change to this directory
	echo `date` > $log
	cat $cf >> $log

	runOccurs=`grep run= $cf | grep -v ^# | wc -l`						#Count number of occurrencies for run=
	npOccurs=`grep np= $cf | grep -v ^# | wc -l`						#Count number of occurrencies for np=
	
	if (( $runOccurs == 1 )); then

		if (( $npOccurs == 1 )); then
			runline=`grep run= $cf | grep -v ^#`					#Get the line containing run=
			run=${runline:4}							#Extract the value using substring
			
			npline=`grep np= $cf | grep -v ^#`					#Get the line containing np=
			np=${npline:3}								#Extract the value using substring
			
			if (( "$np" -ne "" )); then						#If number of procs was entered...
				if (( "$np" < 25 )); then
					case "$run" in
						nmr)
							qsub -A $pn -pe orte $np /net/software/cluster/nmr.sh >>$log 2>&1
							jobline=`grep "Your job" $log`
							jobid=${jobline:9:4}
							qalter -p -500 $jobid >>$log 2>&1
							;;
						abs)
							qsub -A $pn -pe orte $np /net/software/cluster/absolutepermeability.sh >>$log 2>&1
							jobline=`grep "Your job" $log`
							jobid=${jobline:9:4}
							qalter -p -500 $jobid >>$log 2>&1
							;;
						ff)
							qsub -A $pn -pe orte $np /net/software/cluster/elcond.sh >>$log 2>&1
							jobline=`grep "Your job" $log`
							jobid=${jobline:9:4}
							qalter -p -500 $jobid >>$log 2>&1
							;;
						*)
							#Not OK
							echo "$run is not a valid cluster application. Aborting." >> $log
							;;
					esac
			
				else	#If they requested more than 24, abort.
					echo "Too many cores requested. Req=$np but Max=$mc. Aborting." >> $log
				fi
			
			else	#np was empty...
				echo "np= statement declared without a value. Aborting." >> $log
			fi		

		else	#If np= occurs more or less than once, abort.
			echo "Error: the 'np=' statement occurred $npOccurs times. Aborting." >> $log
		fi
	
		else	#If run= occurs more or less than once, abort.
		echo "Error: the 'run=' statement occurred $runOccurs times. Aborting." >> $log
	fi
	rm $cf
done
