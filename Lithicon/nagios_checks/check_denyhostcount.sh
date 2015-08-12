#!/bin/bash

# ---------------------------- #
# Count number of denied hosts #
# ---------------------------- #

denied=$(grep -v ^# /etc/hosts.deny|grep -v ^$|wc -l)
echo "Number of hosts in /etc/hosts.deny: $denied"
exit 0
