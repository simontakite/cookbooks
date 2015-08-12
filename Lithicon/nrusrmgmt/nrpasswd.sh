#!/bin/bash
# Read password from user
# save it in a variable
# use it for passwd, yppasswd, and sbbpasswd

#echo -n "Write something: "
#read inputText
#echo "You wrote: $inputText"

# -- Create vars

OK=0
E_NOSUCHUSER=70
SUCCESS=0

# -- Read and check username

read -p "Enter username: " username
grep -q "^${username}:" /etc/passwd

if [ $? != $SUCCESS ]
then
	echo "User $username not found."
	echo "No password modified."
	exit $E_NOSUCHUSER						# Possible exit poinnt
fi


# -- Read and verify new password
echo "Modifying password for user: $username"
while [ "$OK" == "0" ]
do

	read -s -p "Create password (min 7 chars): " passvar
	echo
	read -s -p "Re-enter password: " passvar2

	if [ "$passvar" == "$passvar2" ]
	then	
		OK=1
	else
		echo
		echo "Passwords do not match. Try again."
	fi
done

# -- Change password

echo $passvar | passwd --stdin "$username"
echo -n -e "$passvar\n$passvar" | smbpasswd -s "$username"
cd /var/yp
make

# yppassword........?


# -- Unset password vars
passvar=nothing
passvar2=nothing

exit 0
