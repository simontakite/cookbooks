#!/bin/bash

fstab="/etc/fstab"

# change temp line
tempserver=$(grep "/net/temp" $fstab|awk {'print $1'}|cut -d ':' -f1)

if [[ "$tempserver" == "10.10.10.10" ]] || [[ "$tempserver" == "santiago"  ]];then
   echo "Redirecting /net/temp to bits..."
   sed -i "s^$tempserver:/san/temp^10.10.10.20:/vol/temp^" $fstab
fi

# comment out projects line and insert separate ts and rd lines
projects="$(grep -e '^[a-Z0-9].*projects.*' $fstab|awk {'print $1'}|cut -d ':' -f2)"

if [[ "$projects" == "/vol/projects" ]];then
   echo "Setting up projects/rd & proj/ts..."
   grep -q projects /proc/mounts && umount /net/projects
   sleep 1
   mkdir /net/projects/ts
   mkdir /net/projects/rd

   sed -i 's^\(.*/vol/projects.*\)^#\1^' $fstab
   (
   echo "10.10.10.20:/vol/projects/rd /net/projects/rd nfs defaults 0 0"
   echo "10.10.10.20:/vol/proj/ts /net/projects/ts nfs defaults 0 0"
   ) >> $fstab
fi
