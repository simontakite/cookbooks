#!/bin/bash

#if cat /var/lib/dhcpd/dhcpd.leases | grep -q "my state normal"

laststate=`grep 'my state' /var/lib/dhcpd/dhcpd.leases|tail -n 1`

if echo $laststate | grep -q "my state normal"
then 
	echo "OK - `grep 'my state' /var/lib/dhcpd/dhcpd.leases|tail -n 1`"
	exit 0;
else
	echo "WARNING - `grep 'my state' /var/lib/dhcpd/dhcpd.leases|tail -n 1`"
	exit 1;
fi
