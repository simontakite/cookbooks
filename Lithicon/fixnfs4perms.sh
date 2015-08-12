#!/bin/bash

# ----------------------------------------------------- #
# fixnfs4perms.sh by torad 	last edit: 02.12.2009	#
# ----------------------------------------------------- #
# Purpose:						#
# - Reset permissions on a directory structure		#
# + to the NR-default permission/inheritance system	#
# ----------------------------------------------------- #

me=$(basename $0)
error="Incorrect amount of arguments passed."

function usage {
   echo "Error: $error"
   echo "Usage: $me <target dir> <group> <template dir>"
   echo " - Target and template must be mounted with nfs4 for this script to work"
   echo
   exit 1
}

# Print usage and exit if argument count != 3
(( $# != 3 )) && usage

targetdir=$1
group=$2
templatedir=$3

# Verify validity of entered arguments
[ ! -d $targetdir ] && error="Directory $targetdir does not exist" && usage
getent group $group >/dev/null
groupok=$?
(( $groupok != 0 )) && error="Group $group does not exist" && usage
[ ! -d $templatedir ] && error="Directory $templatedir does not exist" && usage
[ $targetdir == $templatedir ] && error="Target dir and template dir cannot be equal" && usage

# Make sure target volume is mounted with nfs4
if (( $(echo $targetdir|grep -c ^/) == 1)); then
   volume=$(echo $targetdir|cut -d '/' -f3)
else
   volume=$(echo $PWD|cut -d '/' -f3)
fi
targetnfs4mounts=$(cat /proc/mounts|grep $volume|grep -c nfs4)
(( $targetnfs4mounts != 1 )) && error="Volume $volume not mounted with nfs4" && usage

# Make sure template volume is mounted with nfs4
if (( $(echo $templatedir|grep -c ^/) == 1)); then
   volume=$(echo $templatedir|cut -d '/' -f3)
else
   volume=$(echo $PWD|cut -d '/' -f3)
fi
templatenfs4mounts=$(cat /proc/mounts|grep $volume|grep -c nfs4)
(( $templatenfs4mounts != 1 )) && error="Volume $volume not mounted with nfs4" && usage

# Tests passed - Go for it
echo "Changing permissions recursively for $targetdir to match $templatedir:"
chown .$group $targetdir
nfs4_getfacl $templatedir | nfs4_setfacl -R -S - $targetdir
find $targetdir -type d -exec chmod g+s {} \;
find $targetdir -type f -exec chmod -x {} \;

ls -ld $targetdir
ls -l $targetdir
