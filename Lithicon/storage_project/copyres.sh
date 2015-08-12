#!/bin/bash

LOG="/net/resources/res.log"

#MODE=$1
#if [[ $MODE != "-u" ]]; then
#   unset MODE
#else
#   MODE="u"
#fi

CFLAGS="-ru"
RFLAGS="-lort --delete-after"

date > $LOG

cp /home/projects/BIL.xls /net/resources/Sportsclub/

cp $CFLAGS /home/projects/Articles/* /net/resources/Articles/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Articles/ /net/resources/Articles/		>>$LOG 2>&1

cp $CFLAGS /home/projects/Employee\ CVs\,\ photos\,\ job\ desc/* /net/resources/Employees/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Employee\ CVs\,\ photos\,\ job\ desc/ /net/resources/Employees/		>>$LOG 2>&1

cp $CFLAGS /home/projects/Forms\ \&\ Info/* /net/resources/Forms-Info/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Forms\ \&\ Info/ /net/resources/Forms-Info/		>>$LOG 2>&1

cp $CFLAGS /home/projects/HSE/* /net/resources/HSE/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/HSE/ /net/resources/HSE/		>>$LOG 2>&1

cp $CFLAGS /home/projects/Logos\ New/* /net/resources/Logos-Templates/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Logos\ New/ /net/resources/Logos-Templates/		>>$LOG 2>&1

cp $CFLAGS /home/projects/Meetings/* /net/resources/Meetings/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Meetings/ /net/resources/Meetings/		>>$LOG 2>&1

cp -ru /home/projects/Numerical\ Rocks_Activity\ Competition/ /net/resources/Sportsclub/
cp /home/projects/squash.xls /net/resources/Sportsclub/

cp $CFLAGS /home/projects/Seminars/* /net/resources/Seminars/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Seminars/ /net/resources/Seminars/		>>$LOG 2>&1

cp $CFLAGS /home/misc/Templates/Word/ /net/resources/Logos-Templates/		>>$LOG 2>&1
rsync $RFLAGS /home/misc/Templates/Word /net/resources/Logos-Templates/		>>$LOG 2>&1

date >> $LOG
