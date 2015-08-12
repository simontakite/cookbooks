#! /usr/bin/perl -w
#
# check_openvpn_clients.pl - nagios plugin 
# 
#
# Copyright (C) 2004 Gerd Mueller / Netways GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#

use POSIX;
use strict;
use lib "/opt/nagios/libexec"  ;

my %ERRORS = ('UNKNOWN'  => '-1',
              'OK'       => '0',
              'WARNING'  => '1',
              'CRITICAL' => '2');


use Getopt::Long;
Getopt::Long::Configure('bundling');

my $opt_c=20;
my $opt_w=10;
my $opt_h;
my $opt_n;

my $statusfile="/var/run/openvpn/uservpn.status";

my $status;

my $PROGNAME = "check_hopcount";


$status = GetOptions(
                "h"   => \$opt_h, "help"       => \$opt_h,
                "c=s" =>\$opt_c,
                "w=s" =>\$opt_w,
                "n"   =>\$opt_n,
                "S=s" => \$statusfile, "statusfile=s" => \$statusfile);

if(!$opt_c || !$opt_w || $opt_h || $status==0) {
        print_usage() ;
}

my $count_file=0;
my $count=0;

my $errorcode = $ERRORS{'OK'};
my $output;
my $names="";
my $user;
my $dummy;

if(-e $statusfile) {
        open(LOGFILE,"< ".$statusfile);

        while(<LOGFILE>) {
                chomp();
                if(m/^Common Name,Real Address,Bytes Received,Bytes Sent,Connected Since$/) {
                        $count_file=1;
                } elsif(m/^ROUTING TABLE$/) {
                        last;
                } elsif ($count_file) {
                        $count++;
                        ($user,$dummy)=split(/,/);
                        $names.="," if($names ne "");
                        $names.=$user;
                }
        }
        close(LOGFILE);

    $output=$count." connection";
    $output.="s" if($count!=1);
    $output.="<br>User: ".$names if($opt_n && $names ne "");
    if($count>=$opt_c) {
        $errorcode = $ERRORS{'CRITICAL'};
    } elsif($count>=$opt_w) {
        $errorcode = $ERRORS{'WARNING'};
    }
   # original: $output.= " | 'OpenVPN Client Connections'=".$count.";".$opt_w.";".$opt_c."\n";
    $output.= ": $names\n";
} else {
        $output =' Status is unknown because $statusfile was not found! \n ';
        $errorcode = $ERRORS{'UNKNOWN'};
}

print $output;
exit $errorcode;


sub print_usage {
                                        printf "\n";
                                        printf "check_openvpn_clients.pl -S <STATUSFILE> -w n -c n \n";
                                        printf "Copyright (C) 2004 Gerd Mueller / Netways GmbH\n";
                                        printf "\n\n";
                                        exit $ERRORS{"UNKNOWN"};
                                }

