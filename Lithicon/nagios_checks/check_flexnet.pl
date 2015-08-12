#!/usr/bin/perl

$input=`/opt/flexnet/lmstat -a -c /opt/flexnet/lic/ecore_floating.lic | grep ecore_client`;	#Read status
@bits=split(/ +/, $input);									#Split the string on whitespace and store in an array

$MAX=@bits[5];											#Assign item 6 (num licenses) to $MAX
$USED=@bits[10];										#Assign item 11 (used licenses) to $USED

if ($USED>=$MAX){
	print "Warning - $USED of $MAX licenses currently in use!\n";
	exit 1;
}
else{
	print "OK - $USED of $MAX licenses currently in use.\n";
	exit 0;
}
