#!/usr/bin/perl
@names=("Muriel","Sarah","Susanne","Gavin");

&look;

@middle=splice (@names, 1, 1,"Guri");

&look;

sub look {
        print "Names : @names\n";
        print "The Splice Girls are: @middle\n";
}
