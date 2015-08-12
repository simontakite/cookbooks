#!/bin/bash

sigquit()
{
    echo "Signal QUIT received."
}

sigint()
{
    echo "Signal INT received, script ending."
    exit 0
}

sigtstp()
{
    echo "SIGTSTP received." > /dev/tty
    trap - TSTP
    echo "SIGTSTP standard handling restored."
}

trap 'sigquit' 	QUIT
trap 'sigint' 	INT
trap 'sigtstp'	TSTP
trap ':'	HUP

echo "$0 started. PID=$$"

while true;do sleep 30;done
