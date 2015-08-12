#!/bin/bash

NEWDIRS=( "/net" "/net/users" "/net/departments" "/net/projects" "/net/resources" "/net/software" "/net/jungle" )
OLDDIRS=( "/state/users" "/state/technicalservices" "/state/projects" "/state/updates" "/state/misc" "/state/developers" )

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
echo "10.10.10.20:/vol/users /net/users nfs rw,rsize=65536,wsize=65536,hard,proto=tcp,timeo=600,retrans=2,addr=10.10.10.20 0 0" >> /tmp/fstab.bits
echo "10.10.10.20:/vol/departments /net/departments nfs rw,rsize=65536,wsize=65536,hard,proto=tcp,timeo=600,retrans=2,addr=10.10.10.20 0 0" >> /tmp/fstab.bits
echo "10.10.10.20:/vol/resources /net/resources nfs rw,rsize=65536,wsize=65536,hard,proto=tcp,timeo=600,retrans=2,addr=10.10.10.20 0 0" >> /tmp/fstab.bits
echo "10.10.10.20:/vol/projects /net/projects nfs rw,rsize=65536,wsize=65536,hard,proto=tcp,timeo=600,retrans=2,addr=10.10.10.20 0 0" >> /tmp/fstab.bits
echo "10.10.10.20:/vol/software /net/software nfs rw,rsize=65536,wsize=65536,hard,proto=tcp,timeo=600,retrans=2,addr=10.10.10.20 0 0" >> /tmp/fstab.bits
echo "10.10.10.20:/vol/jungle /net/jungle nfs rw,rsize=65536,wsize=65536,hard,proto=tcp,timeo=600,retrans=2,addr=10.10.10.20 0 0" >> /tmp/fstab.bits

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

# Link /state/technicalservices/bin to /net/software/cluster so jobs that were submitted prior to the transition remain valid
ln -s /net/software/cluster /state/technicalservices/bin

# Mount according to fstab
echo "Mounting new filesystems"
mount -a

