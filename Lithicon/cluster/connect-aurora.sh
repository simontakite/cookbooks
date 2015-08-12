#!/bin/bash

# Load fuse kernel module, if not loaded
#if ! grep fuse /proc/filesystems; then
#   /sbin/service fuse start;
#fi

# Create mountpoint if not existing
#if [[ ! -d /net/aurora ]]; then
#   echo "Creating mountpoint"
#   mkdir /net/aurora
#fi

# Mount if not already mounted
if ! grep -qw sshfs /proc/mounts; then
   echo "Connecting"
   /usr/bin/sshfs numerical@10.10.50.7:/mnt/ibrix/home/numerical /net/aurora
fi
