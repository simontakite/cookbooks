#!/usr/bin/perl

print "Skriv noe: ";
chop ($string=<STDIN>);
$teller=length($string);

while($teller >= 0) {
	print "$string\n";
	chop $string;
	$teller--;
}
