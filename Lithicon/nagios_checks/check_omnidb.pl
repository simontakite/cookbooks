#!/usr/bin/perl

#-------------------------------------------------------------------#
# Check DP6 database for last status of each job type		    #
# - Execute with jobspec as the only argument (ex. LINUX_DIFF)	    #
# ----------------------------------------------------------------- #
# - Nagios return codes: 0=normal, 1=warning, 2=critical, 3=unknown #
# ----------------------------------------------------------------- #
# - statusarr[0] = JobID					    #
# - statusarr[1] = Job Type					    #
# - statusarr[2] = Job Status					    #
# ----------------------------------------------------------------- #
# Last edit: 21.01.2009 by torad				    #
#-------------------------------------------------------------------#

$BACKUP_SPEC=shift;									#shift retrieves command-line arguments
@rawoutput=`/opt/omni/bin/omnidb -session -type backup -datalist $BACKUP_SPEC -latest`;	#execute shell command
$statusline=splice(@rawoutput,2,1);							#pick out the one interesting line
@statusarr=split(/ +/, $statusline);							#split the line on whitespace and put the items in an array


$jobid = $statusarr[0];
$jobstatus = $statusarr[2];

print "Job $jobid exited with status $jobstatus\n";


if ($jobstatus eq "Completed"){
	exit 0;
}
elsif ($jobstatus eq "Completed/Errors"){
	exit 0;
}
elsif ($jobstatus eq "Completed/Failures"){
	exit 1;
}
elsif ($jobstatus eq "Failed"){
	exit 2;
}
elsif ($jobstatus eq "Aborted"){
	exit 1;
}
elsif ($jobstatus eq "In"){								#if the job is in progress then $jobstatus will equal "In"
	exit 0;
}
else{
	exit 3;
}
