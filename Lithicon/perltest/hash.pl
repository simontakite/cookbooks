#!/usr/bin/perl

%countries=('NO','NORWAI','NL','The Netherlands','BE','Belgium','DE','Germany','MC','Monaco','ES','Spain');
print "Keys: ",keys %countries,"\n";
print "Values: ",values %countries,"\n";
print "NO and NL: ",@countries{'NO','NL'},"\n";
print "Element count: ",scalar(keys %countries),"\n";
print "It's there!\n" if exists $countries{'NL'},"\n";

while (($code,$name)=each %countries) {
        print "The key $code contains $name\n";
}
