#!/bin/bash

LOG="/net/adm/adm.log"

#MODE=$1
#if [[ $MODE != "-u" ]]; then
#   unset MODE
#else
#   MODE="u"
#fi

CFLAGS="-ru"
RFLAGS="-lort --delete-after"

date > $LOG

## Since administration is non-public, scp it all then sort it
scp -pr root@santiago:/home/users/administration /net/adm/

## Admin ##

cp $CFLAGS /net/adm/administration/Correspondence/ /net/adm/admin/		>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/Correspondence /net/adm/admin/		>>$LOG 2>&1

cp $CFLAGS /net/adm/administration/Finance/ /net/adm/admin/			>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/Finance /net/adm/admin/			>>$LOG 2>&1

cp $CFLAGS /net/adm/administration/Generalforsamlinger/ /net/adm/admin/		>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/Generalforsamlinger /net/adm/admin/	>>$LOG 2>&1

cp $CFLAGS /net/adm/administration/Insurances\ \&\ Pension/ /net/adm/admin/	>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/Insurances\ \&\ Pension /net/adm/admin/	>>$LOG 2>&1

cp $CFLAGS /net/adm/administration/Legal/ /net/adm/admin/			>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/Legal /net/adm/admin/			>>$LOG 2>&1

cp $CFLAGS /net/adm/administration/Personnel/ /net/adm/admin/			>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/Personnel /net/adm/admin/			>>$LOG 2>&1

cp $CFLAGS /net/adm/administration/Shares/ /net/adm/admin/			>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/Shares /net/adm/admin/			>>$LOG 2>&1

cp $CFLAGS /net/adm/administration/The\ Board/ /net/adm/admin/			>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/The\ Board /net/adm/admin/		>>$LOG 2>&1

cp $CFLAGS /net/adm/administration/Office\ -\ Premises/ /net/adm/admin/		>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/Office\ -\ Premises /net/adm/admin/		>>$LOG 2>&1

## Management ##

cp $CFLAGS /net/adm/administration/Management\ Group/ /net/adm/management/		>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/Management\ Group /net/adm/management/		>>$LOG 2>&1

cp $CFLAGS /net/adm/administration/Strategy\ \&\ Plans/ /net/adm/management/		>>$LOG 2>&1
rsync $RFLAGS /net/adm/administration/Strategy\ \&\ Plans /net/adm/management/		>>$LOG 2>&1

cp $CFLAGS /home/projects/Produktplan/ /net/adm/management/
rsync $RFLAGS /home/projects/Produktplan /net/adm/management/

## Destroy temp-data ##

rm -rf /net/adm/administration/

date >> $LOG
