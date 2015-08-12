#! /bin/sh
######################################################################
# Name: check_hparray
# By: Copyright (C) 2007 Magnus Glantz
# Credits to: andreiw
######################################################################

# Rewritten by torad - 24.11.2009 - updated 10.03.2010

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
REVISION=`echo '$Revision: 1.0 $' | sed -e 's/[^0-9.]//g'`
HPACUCLI=/usr/sbin/hpacucli

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

#ch=SANdisk1 <--- replaced by $2 

print_usage() {
        echo ""
        echo "Usage: $PROGNAME -s <slot-number>"
        echo "Usage: $PROGNAME [-h | --help]"
        echo "Usage: $PROGNAME [-V | --version]"
        echo ""
        echo " NOTE:"
        echo ""
        echo " HPACUCLI needs administrator rights."
        echo " add this line to /etc/sudoers"
        echo " nagios      ALL=NOPASSWD: /usr/sbin/hpacucli"
        echo ""
}

print_help() {
        print_revision $PROGNAME $REVISION
        echo ""
        print_usage
        echo ""
        echo "This plugin checks hardware status for HP Proliant servers using HPACUCLI utility."
        echo ""
        support
        exit 0
}

if [ $# -lt 1 ]; then
    print_usage
    exit $STATE_UNKNOWN
fi

check_raid()
{
        raid_ok=`echo $check|grep -i ok|wc -l`
	# Define warning states:
        raid_warning_1=$(echo $check|grep -i rebuild|wc -l)
        raid_warning_2=$(echo $check|grep -i recovering|wc -l)
        raid_warning_3=$(echo $check|grep -i expanding|wc -l)
        # Define critical states:
	raid_critical_1=`echo $check|grep -i failed|wc -l`
        raid_critical_2=`echo $check|grep -i recovery|wc -l`

        err_check=`expr $raid_ok + $raid_warning_1 + $raid_warning_2 + $raid_critical_1 + $raid_critical_2`

        if [ $err_check -eq "0" ]; then
                checkm=`echo $check|sed -e '/^$/ d'`
                echo "$PROGNAME Error. $checkm"
                exit 2
        fi

        info=$check

        if (( $raid_critical_1 >= 1 )) || (( $raid_critical_2 >= 1 )); then
                exitstatus="CRITICAL"
                exitcode=$STATE_CRITICAL
        elif (( $raid_warning_1 >= 1 )) || (( $raid_warning_2 >= 1 )) || (( $raid_warning_3 >= 1  )); then
                exitstatus="WARNING"
                exitcode=$STATE_WARNING
        elif (( $raid_ok >= 1 )); then
                exitstatus="OK"
                exitcode=$STATE_OK
        else
                exitstatus="UNKNOWN"
                exitcode=$STATE_UNKNOWN
        fi

        echo $exitstatus - $info.
        exit $exitcode
}


case "$1" in
        --help)
                print_help
                exit 0
                ;;
        -h)
                print_help
                exit 0
                ;;
        --version)
                print_revision $PROGNAME $REVISION
                exit 0
                ;;
        -V)
                print_revision $PROGNAME $REVISION
                exit 0
                ;;
        -s)
                check=`sudo -u root $HPACUCLI controller slot=$2 ld all show`
                check_raid
                ;;
        -msa)	
                check=$(sudo -u root $HPACUCLI ctrl ch=$2 ld all show)
                check_raid
                ;;
        *)
                print_usage
                ;;
esac
