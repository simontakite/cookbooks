#!/bin/bash

# Dismount if mounted
if grep -qw sshfs /proc/mounts; then
   echo "Disconnecting"
   /usr/bin/fusermount -u /net/aurora
fi

# Unload the kernel module if loaded
#if grep -qw fuse /proc/filesystems; then
#   /sbin/service fuse stop
#fi

# Remove the mountpoint if unmounted
#if ! grep -qw sshfs /proc/mounts; then
#   echo "Removing mountpoint"
#   rm -r /net/aurora
#fi
