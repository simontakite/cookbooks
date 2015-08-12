#!/bin/bash

# Insert a hash char (#) at the start of the line containing 'jungle' in fstab
sed -i 's/\(.*jungle.*\)/#\1/' /etc/fstab

# Unmount jungle
umount /net/jungle

grep jungle /etc/fstab
grep jungle /proc/mounts
