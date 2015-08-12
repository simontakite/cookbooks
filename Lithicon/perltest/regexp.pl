#!/usr/bin/perl

print "What do you read before joining any Perl discussion ? ";
chomp ($_=<STDIN>);

print "Your answer was : $_\n";

if ($_=~/the faq/) {
        print "Right !  Join up !\n";
} else {
        print "Begone, vile creature !\n";
}
