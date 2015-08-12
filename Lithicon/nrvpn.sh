#!/bin/bash

#---------------------------------------#
# Numerical Rocks AS VPN Control Script #
# - start:                              #
# -- Start OpenVPN                      #
# -- Mount NFS                          #
# - stop:                               #
# -- Unmount NFS                        #
# -- Kill OpenVPN                       #
# - status:                             #
# -- Display whether OpenVPN is running #
#---------------------------------------#

# Note: NFS filesystems must be present in fstab with user,exec,suid,tcp options

# Source functions to be able to use success and failure
. /etc/rc.d/init.d/functions

case "$1" in
   start)
        running=0
        clear
        echo "Numerical Rocks AS VPN"
        echo "----------------------"
        # OpenVPN exits silently on auth failure -- add loop to catch auth failures and retry
        while [ $running -eq 0 ]; do
                /usr/sbin/openvpn --daemon nrvpn --config /etc/openvpn/*.conf
                echo -n "Starting OpenVPN: "
                sleep 5
                numprocs=$(ps ax | grep openvpn | grep -v grep | wc -l)
                if [ $numprocs -gt 0 ]; then
                        running=1
                        success $"Starting OpenVPN"
                        echo
                else
                        failure $"Starting OpenVPN"
                        echo
                fi
        done
        # Attempt to mount NFS filesystems
        echo -n "Mounting /net/users: "
        mount /net/users 2>/dev/null
        if [ $? -ne 0 ]; then
                failure $"users"
        else
                success $"users"
        fi
        echo
        echo -n "Mounting /net/departments: "
        mount /net/departments 2>/dev/null
        if [ $? -ne 0 ]; then
                failure $"departments"
        else
                success $"departments"
        fi
        echo
        echo -n "Mounting /net/resources: "
        mount /net/resources 2>/dev/null
        if [ $? -ne 0 ]; then
                failure $"resources"
        else
                success $"resources"
        fi
        echo
        echo -n "Mounting /net/software: "
        mount /net/software 2>/dev/null
        if [ $? -ne 0 ]; then
                failure $"software"
        else
                success $"software"
        fi
        echo
        echo -n "Mounting /net/projects: "
        mount /net/projects 2>/dev/null
        if [ $? -ne 0 ]; then
                failure $"projects"
        else
                success $"projects"
        fi
        echo
        echo -n "Mounting /net/jungle: "
        mount /net/jungle 2>/dev/null
        if [ $? -ne 0 ]; then
                failure $"jungle"
        else
                success $"jungle"
        fi
        echo
        ;;
  stop)
        # Check for open files before attempting to unmount
        echo -n "Unmounting NFS filesystems: "
        failures=0
        Jstat=$(lsof|grep /net/jungle|wc -l)
        Sstat=$(lsof|grep /net/software|wc -l)
        Pstat=$(lsof|grep /net/projects|wc -l)
        Rstat=$(lsof|grep /net/resources|wc -l)
        Ustat=$(lsof|grep /net/users|wc -l)
        Dstat=$(lsof|grep /net/departments|wc -l)
        if [ $Jstat -ne 0 ]; then failures=1; fi
        if [ $Sstat -ne 0 ]; then failures=1; fi
        if [ $Pstat -ne 0 ]; then failures=1; fi
        if [ $Rstat -ne 0 ]; then failures=1; fi
        if [ $Ustat -ne 0 ]; then failures=1; fi
        if [ $Dstat -ne 0 ]; then failures=1; fi
        if [ $failures -eq 0 ]; then
                umount /net/* 1>/dev/null
                success $"Unmount"
                echo
                echo -n "Stopping OpenVPN: "
                killall openvpn
                success $"Stopping OpenVPN"
                echo
        else
                failure $"Unmount"
                echo
                echo "- Make sure there is no open files under /net." 
                echo "- Make sure the current working directory in your terminal(s) is not within /net."
        fi
        ;;
  status)
        numprocs=$(ps ax | grep openvpn | grep -v grep | wc -l)
        if [ $numprocs -gt 0  ]; then
                status="running."
        else
                status="NOT running."
        fi
        echo "OpenVPN is $status"
        ;;
  *)
        echo "Usage: nrvpn start|stop|status"
        exit 1
        ;;
esac

