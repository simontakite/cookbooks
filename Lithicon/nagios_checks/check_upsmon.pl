#!/usr/bin/perl
$input=`/sbin/pidof upsmon`;								#Get upsmon pids
@pids=split(/ +/, $input);								#Split on whitespace and store pid(s) in array
$procs = scalar(@pids);									#Count number of pids (=procs)

if ($procs < 2){									#If there's only one element, it may be whitespace
	if ($pids[0] == ""){								#In that case, upsmon has no pid (=not running)
		print "CRITICAL - upsmon not running\n";
		exit 2;
	}

	else {										#If it's not nothing, it's a  pid
		print "WARNING - upsmon running $procs process with pid @pids";
		exit 1;
	}
}
else{											#If there's 2 pids in the array, everything is fine
	print "OK - upsmon running $procs procs with pids @pids";
	exit 0;
}


