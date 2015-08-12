#!/usr/bin/perl
# anders@fupp.net, 2007-12-03
# Nagios plugin to check ciss RAID volumes using cciss_vol_status
# 
# 2008-07-21: Fix output slightly for cciss_vol_status oddities and whitespace
# 2008-07-30: More odd character/text output fixes

use POSIX;

# Settings
# If set to 1, print all volumes:
$printall = 1;
# If set to 1, print all volumes even when something has failed:
$printallfail = 0;

$ENV{PATH} = $ENV{PATH} . ":/usr/local/bin";
$os = (POSIX::uname)[0];
$cmd = "cciss_vol_status";
if ($< != 0) {
	$cmd = "sudo -u root $cmd";
}

if ($os eq "Linux") {
	$devdir = "/dev/cciss";
	$devmatch = '^c\d+d\d+$';
	$devname = "cciss";
} else {
	# FreeBSD and others
	$devdir = "/dev";
	$devmatch = '^ciss\w+$';
	$devname = "ciss";
}

opendir(DIR, $devdir);
@cissdevs = grep { /$devmatch/ && ( -c "$devdir/$_" || -b "$devdir/$_" ) } readdir(DIR);
closedir(DIR);
if (!@cissdevs) {
	print "No $devname devices found. Status unknown.\n";
	exit(3);
}

# 0=ok, 1=warning, 2=critical
$state = 0;

foreach $cdev (@cissdevs) {
	$output=`$cmd $devdir/$cdev 2>/dev/null`;
	$ret=$?;

	$alldevout="";
	foreach $devout (split /\n/, $output) {
		$devout =~ s@.* RAID (\d+) Volume (\d+).*? status: (.+?)\s*$@$cdev/${2}/RAID${1}: ${3}@;
		$devout =~ s@\.$@@;
		$alldevout .= "$devout, ";
	}
	# Filter some characters
	# Comma+space on the end:
	$alldevout =~ s@, $@@;
	# cciss_vol_status oddities:
	$alldevout =~ s@//@@g;
	$alldevout =~ s@'@@g;
	$alldevout =~ s@:, @: @g;
	# Multiple whitespace = space:
	$alldevout =~ s@\s+@ @g;

	if ($ret == 0) {
		$oktxt .= $alldevout . ", ";
	} elsif ($ret == 4 || $ret == 5 || $ret == 10) {
		# warning
		if ($state != 2) { $state = 1; }
		$warntxt .= $alldevout . ", ";
	} else {
		# critical
		$state = 2;
		$crittxt .= $alldevout . ", ";
	}
}

if ($oktxt) { $oktxt =~ s@, $@@g; }
if ($warntxt) { $warntxt =~ s@, $@@g; }
if ($crittxt) { $crittxt =~ s@, $@@g; }

#print "DEBUG, oktxt=$oktxt\n";
#print "DEBUG, warntxt=$warntxt\n";
#print "DEBUG, crittxt=$crittxt\n";
#print "DEBUG, state=$state\n";

if ($state == 0) {
	if ($printall == 1) {
		print "$oktxt.\n";
	} else {
		print "All RAID volumes OK.\n";
	}
} elsif ($state == 1) {
	# warning
	$mytxt = $warntxt;
	if ($printall == 1 && $printallfail == 1) {
		if ($oktxt) { $mytxt .= ", $oktxt"; }
	}
	print "$mytxt\n";
} elsif ($state == 2) {
	# critical
	$mytxt = $crittxt;
	if ($warntxt) { $mytxt .= ", $warntxt"; }
	if ($printall == 1 && $printallfail == 1) {
		if ($oktxt) { $mytxt .= ", $oktxt"; }
	}
	print "$mytxt\n";
} else {
	print "Unknown status.\n";
	exit(3);
}

exit($state);

