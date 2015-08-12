#!/bin/bash
# Add user & smb user

EXISTS=0
OK=0

echo "Adding new Numerical Rocks user."
read -p "Username: " username

grep -q "^${username}:" /etc/passwd

if [ $? = $EXISTS  ]
then
	echo "User $username already exists."
	echo "No user added."
else
	while [ $OK == 0 ]
	do
		read -p "developers or users?: " homeserv
		
		case "$homeserv" in
		"developers")
			OK=1
			;;
		"users")
			OK=1
			;;
		*)
			echo "Invalid input, try again."
			;;
		esac
			

	done
	read -p "Enter primary group id (90 or 100): " group
	
	adduser -g $group -d /home/$homeserv/$username $username
	smbpasswd -a -n $username
fi
