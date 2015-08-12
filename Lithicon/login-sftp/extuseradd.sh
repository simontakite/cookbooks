#!/bin/bash

# -----------------------------------------------------	#
# extuseradd.sh by torad				#
# ----------------------------------------------------	#
# Add new external user					#
# - uid > 1000, home => jail, shell => rssh		#
# - generate and set a strong password			#
# - add responsible(s) to new user's primary group	#
# - Set quota						#
# - Add to jailpasswd					#
# - Set expiry						#
# -----------------------------------------------------	#

# Changelog:
## 11.03.2010: added support for soft quota specification
## 02.11.2010: added 'rkhunter --propupd' command at the end
## 02.12.2010: changed default acct expiry from 7 to 30 days
## 02.12.2010: added gecos input

# Make sure the user name was provided
if [ -z "$1" ]; then
   echo "usage: extuseradd.sh <username>"
   exit 1
fi

user=$1

# See whether the user already exists
if grep -q $user /etc/passwd; then
   echo -e "Error: User\e[1m $user\e[0m already exists."
   exit 2
fi

jailpasswd=/ftp/rssh-chroot/etc/passwd
jailhome=/ftp/rssh-chroot/ftp
jailshell=/usr/bin/rssh
quotapart=/ftp

uidprop=$(cat /etc/passwd|grep -v nfsnobody|cut -d ":" -f3|sort -g|tail -n 1)
let uidprop++

# --Get input

echo -e "Adding external user\e[1m $user\e[0m"
read -p "Enter user id (leave blank for default=$uidprop): " uid

if [ "$uid" = "" ];then
   uid=$uidprop
fi

read -p "Enter the full name of the new user: " gecos

read -p "Enter hard quota in megabytes (leave blank for default => 10000 MB): " hard_quota
if [ "$hard_quota" = "" ];then
   hard_quota=10000000
else
   let hard_quota=$hard_quota*1000
fi

let soft_suggest=$hard_quota*9/10000
read -p "Enter soft quota in megabytes (leave blank for default => $soft_suggest MB): " soft_quota
if [ "$soft_quota" = "" ];then
   let soft_quota=$hard_quota*9/10
else
   let soft_quota=$soft_quota*1000
fi
if (( $soft_quota > $hard_quota ));then
   echo "Soft quota cannot be greater than hard quota - setting soft quota = hard quota."
   soft_quota=$hard_quota
fi

expprop=$(date +%Y-%m-%d -d "30 days")

read -p "Enter expiry date (leave blank for default=$expprop): " expire

if [ "$expire" = "" ];then
   expire=$expprop
fi

read -p "Enter user name(s) of responsible user(s). Separate with space: " responsible

echo "--- --- --- --- --- --- ---"

# --Start working

# Add the user
mkdir $jailhome/$user
chmod 2770 $jailhome/$user
useradd -u $uid -d $jailhome/$user -M -s $jailshell -e $expire -c "$gecos" $user
sleep 1
chown $user.$user $jailhome/$user

# Generate and set a strong password
password=$(mkpasswd -l 12 -s 2)
echo $password|passwd --stdin $user 1>/dev/null

# Add responsible user(s) to new user's primary group
if [ "$responsible" != ""  ];then
   for ru in $responsible;do
      if grep -q "^$ru" /etc/passwd;then
         usermod -a -G $uid $ru
      else
         echo "$ru was not added to $user's primary group because that user does not exist."
      fi
   done
fi

# Set quota
setquota -u $user $soft_quota $hard_quota 0 0 $quotapart

# Update jailpasswd
if ! grep -q $user $jailpasswd;then
   getent passwd $user >> $jailpasswd
fi

# Sign out
echo -e "Unless you noticed any errors\e[1m $user\e[0m was successfully created and its password is\e[1m $password\e[0m"

# Update RKHunter database
echo "Running rkhunter --propupd"
rkhunter --propupd &
