#!/bin/bash

####################################################################################
#
# Script to install Numerical Rocks printers to CentOS
# 
# Needs CUPS installed
#
# torhal, 2012-01
#
####################################################################################

cd /etc/cups || exit 1

service cups stop

#yum install hplip3 -y

rm -rf /etc/cups/ppd/*

cd /etc/cups/ppd

wget http://mana/centos/setup/print/blueprint-colour.ppd
wget http://mana/centos/setup/print/blueprint-gray.ppd
wget http://mana/centos/setup/print/greenmfp-colour.ppd
wget http://mana/centos/setup/print/greenmfp-grey.ppd

rm -rf /etc/cups/printers.conf

cd /etc/cups

wget http://mana/centos/setup/print/printers.conf
chmod 600 /etc/cups/printers.conf

service cups start
