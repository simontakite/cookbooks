#!/bin/bash
# delete user and home directory from santiago, nis and samba

echo "Numerical Rocks user deletion script."
echo "Use with caution!!"

read -p "Enter user name: " username
read -p "Type 'delete' to confirm deletion of $username:" confirmation

if [ "$confirmation" != "delete" ]
then
	echo "Confirmation failed."
	echo "User $username not deleted."
else
	userdel -r "$username"
	smbpasswd -x "$username"
	cd /var/yp
	make
	echo "User $username deleted."
fi

exit 0
