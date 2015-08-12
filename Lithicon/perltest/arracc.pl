#!/usr/bin/perl

@lista = ("Arne","Bjarne","Carl","Didrik","Erica");

#print "Skriv en verdi, 0-$#lista: ";
#chomp($index=<STDIN>);
#print "@lista[$index]\n";

#foreach $person (@lista){
#	print "$person\n";
#}

# bruker $_
#foreach (@lista){
#	print; 
#}

#@names  =('Mrs Smith','Mr Jones','Ms Samuel','Dr Jansen','Sir Philip');
#@medics =('Dr Black','Dr Waymour','Dr Jansen','Dr Pettle');

#foreach $person (@names) {
#	if ($person=~/Dr /) {
#		print "$person\n";
#	}
#}

@names=("Muriel","Gavin","Susanne","Sarah");
@cities=("Brussels","Hamburg","London","Breda");

&look;

$last=pop(@names);
unshift (@cities, $last);

&look;

sub look {
        print "Names : @names\n";
        print "Cities: @cities\n";
}
