#!/bin/bash

# ----------------------------------------------------- #
# command-fork.sh by torad				#
# ----------------------------------------------------- #
# Created:	24.02.2010 (?)				#
# Changed:	14.02.2011				#
# Type:		Administration utility / alias target	#
# ----------------------------------------------------- #
# Purpose:                                              #
# - run a command on a group of computers               #
# Required input:                                       #
# - computer group                                      #
# ----------------------------------------------------- #

srv=( "mana" "panama" "bogota" "caracas" "intranet" "lima" "santiago" "webs" )
ws=( "trwsaa" "trwsab" "trwsac" "trwsad" "trwsaf" "trwsag" "alexandria" "suez" "esna" "luxor" "aswan" "cairo" "jakarta" "trwsha" "trwshb" "trwshc" "trwshd" )
dt=( "sofia" "tokyo" "kobe" "trdtaj" "kula" )
vm=( "build-c4-32" "build-c4-64" "build-c5-32" "build-c5-64" )
all=( ${srv[*]} ${ws[*]} ${dt[*]} ${vm[*]} )

scriptname=$(basename $0)

function usage() {
   echo "Usage: $scriptname <computer group> <command>|list"
   echo "- Valid groups are: c (custom), srv (servers), ws (workstations), dt (desktops), vm (VMs), all"
   echo "- Run '$scriptname <computer group> list' to display group members"
   exit 1
}

# Parse input
[ -z "$1" ] || [ -z "$2" ] && usage

case $1 in
   srv)
     comps=${srv[*]}
     ;;
   ws)
     comps=${ws[*]}
     ;;
   dt)
     comps=${dt[*]}
     ;;
   vm)
     comps=${vm[*]}
     ;;
   c)
     read -p "Enter computers to run on, separate by space: " comps
     ;;
   all)
     comps=${all[*]}
     ;;
   *)
      usage
      ;;
esac

case $2 in
   list)
      echo ${comps[*]}
      exit 0
      ;;
   *)
      commandfork=$2
      ;;
esac

# DO IT!
read -p "Run '$commandfork' on ${comps[*]}? y to confirm: " confirm
if [ "$confirm" == "y" ]; then
   for comp in ${comps[*]};do
      #echo "I will do '$commandfork' on $comp"
      echo $comp:
      sleep 2
      ssh -t $comp $commandfork
      echo
   done
else
   echo "Operation aborted."
fi

exit 0
