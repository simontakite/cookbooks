#!/bin/bash

# ------------------------------------- #
# check_sestatus.sh by torad            #
# ------------------------------------- #
# - Return SELinux protection status    #
# - Use in DMZ                          #
# ------------------------------------- #

sestatus=$(getenforce)

case "$sestatus" in
   Enforcing)
        exitcode=0
        message="OK - SELinux is $sestatus."
        ;;
   Permissive)
        exitcode=1
        message="Warning - SELinux is $sestatus."
        ;;
   Disabled)
        exitcode=2
        message="Critical - SELinux is $sestatus."
        ;;
   *)
        exitcode=4
        message="Unknown - SELinux is $sestatus."
        ;;
esac

echo $message
exit $exitcode
