#!/bin/bash

# -----------------------------------------------------	#
# extuserdel.sh by torad                              	#
# -----------------------------------------------------	#
# Remove an external user                             	#
# - Userdel 	                                      	#
# - Groupdel						#
# - Clean /etc/rssh-chroot/etc/passwd			#
# - Remove home directory				#
# - Remove internal mail file				#
# ----------------------------------------------------- #

# Make sure the user name was provided
if [ -z "$1" ]; then
   echo "usage: extuserdel.sh <username>"
   exit 1
fi

user=$1

# See whether the user already exists
if ! grep -q "^$user" /etc/passwd; then
   echo -e "Error: User\e[1m $user\e[0m does not exist."
   exit 2
fi

# Verify that this is an external user
uid=$(grep "^$user" /etc/passwd|cut -d ":" -f3)

if (( $uid < 1000 ));then
   echo -e "Error: User\e[1m $user\e[0m is not an external user (uid=$uid)."
   exit 3;
fi

# Obtain confirmation
read -p "User $user will be deleted along with its home directory, proceed? [yes/no]: " confirm

if [ "$confirm" != "yes" ];then
   echo "Exiting."
   exit 4
fi

jailpasswd=/ftp/rssh-chroot/etc/passwd
jailhome=/ftp/rssh-chroot/ftp
maildir=/var/spool/mail

# --Start working
userdel $user
if grep -q "^$user" /etc/group;then
   groupdel $user
fi
rm -r $jailhome/$user
rm $maildir/$user
grep -v "^$user" $jailpasswd > newpasswd
mv newpasswd $jailpasswd
