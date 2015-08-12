#!/bin/bash

[ -z $1 ] && fp=temp || fp=$1

(echo "
# default: on
# description: NRPE (Nagios Remote Plugin Executor)
service nrpe
{
        flags           = REUSE
        socket_type     = stream
        port            = 5666
        wait            = no
        user            = nagios
        group           = nagios
        server          = /opt/nagios/bin/nrpe
        server_args     = -c /opt/nagios/etc/nrpe.cfg --inetd
        log_on_success  =
        log_on_failure  += USERID
        disable         = no
        only_from       = 127.0.0.1 10.10.10.14
}
") > $fp

cat $fp

read -t5 -p "deleting $fp - write no within 5 seconds to cancel: "

[[ $REPLY == "no" ]] && echo "canceling" || rm $fp

exit 0

