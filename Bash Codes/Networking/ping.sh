#!/bin/bash
#Filename: ping.sh
# Change base address 192.168.0 according to your network.

for ip in 192.168.0.{1..255} ;

    ping $ip -c 2 &> /dev/null ;

do

    if [ $? -eq 0 ];
        then
        echo $ip is alive
    fi

done
