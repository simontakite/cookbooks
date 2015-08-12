#!/usr/bin/perl
use Time::Local;
use POSIX;

#Set Grid Engine variables....

$ENV{'SGE_CELL'} = 'default';
$ENV{'SGE_ARCH'} = 'lx26-amd64';
$ENV{'SGE_EXECD_PORT'} = '537';
$ENV{'SGE_QMASTER_PORT'} = '536';
$ENV{'SGE_ROOT'} = '/opt/gridengine';

@joblist=`/opt/gridengine/bin/lx26-amd64/qstat -s r`;                   #Get the list of currently running jobs

splice(@joblist,0,2);			#Remove header lines from qstat output

for ($i=0;$i<=$#joblist;$i++){
	@job=split(/ +/, $joblist[$i]);		#Splits a @qstat element on whitespace
	splice(@job,0,1);					#For some reason the first and the last element is still just whitespace...
	pop(@job);							#...so we remove them

	$id=$job[0];						#Store jobid,
	$application=$job[2];				#job type, and
	$owner=$job[3];						#owner in separate variables, for better script readability

	@date=split(/\//,$job[5]);			#Split the date element into month-day-year

	$temp=$date[0];						#Switch month-day-year...
	$date[0]=$date[1];					#...to... 
	$date[1]=$temp;						#...day-month-year

	@time=reverse(split(/:/,$job[6]));	#Split the time element into hours-minutes-seconds and reverse order to seconds-minutes-hours
	push(@time,@date);					#Insert day-month-year after hours in the @time array
	
	$time[4]--;							#Decrement the month value as perl counts months from 0 to 11
	$time[5]-=1900;						#Subtract 1900 from the year value as perl uses x years since 1900

	$now=time();
	$secsexec=timelocal(@time);
	$secs=$now-$secsexec;
	$mins=$secs/60;
	$hours=$mins/60;

	#print "Jobben ble startet $secsexec sekunder etter 01.01.1970\n";
	#print "Det vil si $secs sekunder siden - $mins minutter siden - $hours timer siden\n";
	
	if ($hours >= 24){
		$name = ucfirst($owner);
		$floorhours = floor($hours);
		$message = "I would like to remind you $name, that your cluster job with id $id ($application) has been running for more than $floorhours hours.\n
If you have any comments or questions in regards to this message, contact your system administrator.\n\n
Have a nice day!\nThe Lima cluster";
		#send mail.
		open (MAIL, "|/usr/sbin/sendmail -t ");
		print MAIL "From: lima-cluster\@numericalrocks.com\n";
		print MAIL "To: $owner\@numericalrocks.com\n";
		print MAIL "Content-Type: text/plain\n";
		print MAIL "Subject: Cluster job $id\n\n";
		print MAIL $message;
		close (MAIL);
		#print $message;
	}
}
