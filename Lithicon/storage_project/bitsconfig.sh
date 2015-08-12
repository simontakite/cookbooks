#!/bin/bash

NEWDIRS=( "/net" "/net/users" "/net/departments" "/net/projects" "/net/resources" "/net/software" "/net/jungle" )
OLDDIRS=( "/home/users" "/home/technicalservices" "/home/projects" "/home/updates" "/home/misc" "/home/developers" )

# Make sure autofs is stopped and deactivated
/sbin/chkconfig autofs off
ACTIVE=`ps -ef | grep automount | grep -v grep | wc -l`
if (( "$ACTIVE" >= 1 )); then
	echo "Stopping autofs"
	service autofs stop
fi

# Make new mountpoints
for DIR in ${NEWDIRS[@]}; do
	if [[ ! -d $DIR ]]; then
		echo "Creating $DIR"
		mkdir $DIR
	fi
done

# Update fstab
echo "Setting up /etc/fstab"
grep -vi "10.10.10.20" /etc/fstab | grep -vi "bits" | grep -vi "10.10.10.10" | grep -vi "santiago" | grep -vi "10.10.10.15" | grep -vi "bogota" > /tmp/fstab.bits
echo "10.10.10.20:/vol/users /net/users nfs defaults 0 0" >> /tmp/fstab.bits
echo "10.10.10.20:/vol/departments /net/departments nfs defaults 0 0" >> /tmp/fstab.bits
echo "10.10.10.20:/vol/resources /net/resources nfs defaults 0 0" >> /tmp/fstab.bits
echo "10.10.10.20:/vol/projects /net/projects nfs defaults 0 0" >> /tmp/fstab.bits
echo "10.10.10.20:/vol/software /net/software nfs defaults 0 0" >> /tmp/fstab.bits
echo "10.10.10.20:/vol/jungle /net/jungle nfs defaults 0 0" >> /tmp/fstab.bits

mv /etc/fstab /etc/fstab.org
mv /tmp/fstab.bits /etc/fstab

# Disconnect from Santiago and Bogota
for OLD in ${OLDDIRS[@]}; do
	MOUNTED=`grep $OLD /proc/mounts|wc -l`
	if (( "$MOUNTED" == 1 )); then
		echo "Lazy unmounting $OLD"
		umount -l $OLD
	fi
done

# Mount according to fstab
echo "Mounting new filesystems"
mount -a


