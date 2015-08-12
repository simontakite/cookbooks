#!/usr/bin/perl

print "Enter string to be reversed: ";
$input=<STDIN>;

@letters=split //,$input;	# splits on the 'nothings' in between each character of $input

print join ":", @letters;	# joins all elements of @letters with \n, prints it
print reverse   @letters;	# prints all of @letters, but sdrawkcab )-:
