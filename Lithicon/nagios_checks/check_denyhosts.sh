#!/bin/bash

# ----------------------------------- #
# Make sure that DenyHosts is running #
# ----------------------------------- #

running=$(ps ax|grep -v grep|grep denyhosts|wc -l)

if (( $running == 1 )); then
   pid=$(ps ax|grep -v grep|grep denyhosts|cut -d ' ' -f1)
   echo "OK - DenyHosts running with PID $pid."
   exit 0
elif (( $running > 1 )); then
   echo "Manual inspection needed - Status unknown."
   exit 3
else
   echo "Warning - DenyHosts not running."
   exit 1
fi
