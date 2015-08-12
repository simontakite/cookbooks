#!/bin/bash
# Remove old cluster store mount/fstab entry and replace with new, then mount the new one.
mounts=$(cat /proc/mounts)
if ! echo "$mounts" | grep -q "cluster-store"; then
 echo "cluster-store not mounted. Setting up new mount: /net/cluster-store."
 mkdir /net/cluster-store
 cp /etc/fstab /tmp/fstab.old
 grep -v "cluster-store" /tmp/fstab.old>/etc/fstab
 echo "10.10.10.30:/export/cstore /net/cluster-store nfs defaults 0 0">>/etc/fstab
 if [ -d "/home/cluster-store" ]; then
  echo "old mountpoint exists - removing."
  rm -rf /home/cluster-store
 fi
fi
mount -a
ls -l /net/cluster-store
