#!/bin/bash

lang=$1

[ -z $1 ] && echo "Giev language code plz" && exit 1

/usr/bin/setxkbmap $lang



# fra http://www.columbia.edu/~djv/docs/keyremap.html:
# Make the Caps Lock key be a Control key:
xmodmap -e "remove lock = Caps_Lock"
xmodmap -e "add control = Caps_Lock"

# Make the Left Control key be a Caps Lock key:
xmodmap -e "remove control = Control_L"
xmodmap -e "add lock = Control_L"

