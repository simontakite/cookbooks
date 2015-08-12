#!/bin/bash

LOG="/net/jungle/jungle.log"

#MODE=$1
#if [[ $MODE != "-u" ]]; then
#   unset MODE
#else
#   MODE="u"
#fi

CFLAGS="-ru"
RFLAGS="-lort --delete-after"

date > $LOG

cp $CFLAGS /home/projects/Software/ /net/jungle/	>>$LOG 2>&1
rsync $RFLAGS /home/projects/Software /net/jungle/	>>$LOG 2>&1

cp $CFLAGS /home/projects/eCourse/ /net/jungle/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/eCourse /net/jungle/	>>$LOG 2>&1

date >> $LOG
