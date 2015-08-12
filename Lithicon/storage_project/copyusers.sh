#!/bin/bash

LOG="/net/users/users.log"

#MODE=$1
#if [[ $MODE != "-u" ]]; then
#   unset MODE
#else
#   MODE="u"
#fi

#CFLAGS="-ru"
RFLAGS="-a"

date > $LOG

for name in stig
do
  echo $name
  rsync $RFLAGS /home/users/$name /net/users/     >>$LOG 2>&1
  chown .700 /net/users/$name
  chmod 700 /net/users/$name
done

#rsync $RFLAGS /home/users/steelold /net/users/steel/ >>$LOG 2>&1

date >> $LOG

