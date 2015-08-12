#!/bin/bash

LOG="/net/departments/dep.log"

#MODE=$1
#if [[ $MODE != "-u" ]]; then
#   unset MODE
#else
#   MODE="u"
#fi

CFLAGS="-ru"
RFLAGS="-lort --delete-after"

date > $LOG

## Developers ##

cp $CFLAGS /home/updates/temp/nightly/ /net/departments/developers/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/temp/nightly /net/departments/developers/		>>$LOG 2>&1

cp $CFLAGS /home/updates/SC07Tutorials/ /net/departments/developers/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/SC07Tutorials /net/departments/developers/		>>$LOG 2>&1

cp $CFLAGS /home/projects/ecore/ /net/departments/developers/			>>$LOG 2>&1
rsync $RFLAGS /home/projects/ecore /net/departments/developers/			>>$LOG 2>&1

cp $CFLAGS /home/projects/libs/ /net/departments/developers/			>>$LOG 2>&1
rsync $RFLAGS /home/projects/libs /net/departments/developers/			>>$LOG 2>&1

cp $CFLAGS /home/projects/RockLibrary/ /net/departments/developers/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/RockLibrary /net/departments/developers/		>>$LOG 2>&1

## Finance ##

cp $CFLAGS /home/projects/Sales\ \&\ Marketing/Economy\ -\ Finance/* /net/departments/finance/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Sales\ \&\ Marketing/Economy\ -\ Finance/ /net/departments/finance/	>>$LOG 2>&1

## Sales&Marketing

cp $CFLAGS /home/projects/Sales\ \&\ Marketing/* /net/departments/sales-marketing/	>>$LOG 2>&1
rsync $RFLAGS /home/projects/Sales\ \&\ Marketing/ /net/departments/sales-marketing/	>>$LOG 2>&1

cp $CFLAGS /home/projects/Clients/ /net/departments/sales-marketing/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Clients /net/departments/sales-marketing/		>>$LOG 2>&1

rm -r /net/departments/sales-marketing/Economy\ -\ Finance/			>>$LOG 2>&1

cp $CFLAGS /home/projects/Contacts/ /net/departments/sales-marketing/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Contacts /net/departments/sales-marketing/		>>$LOG 2>&1

cp $CFLAGS /home/projects/Co-partners/ /net/departments/sales-marketing/	>>$LOG 2>&1
rsync $RFLAGS /home/projects/Co-partners /net/departments/sales-marketing/	>>$LOG 2>&1

cp $CFLAGS /home/projects/Suppliers/ /net/departments/sales-marketing/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Suppliers /net/departments/sales-marketing/	>>$LOG 2>&1

## IT

cp $CFLAGS /home/updates/flexlm_docs/ /net/departments/it/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/flexlm_docs /net/departments/it/		>>$LOG 2>&1

cp $CFLAGS /home/updates/misc_backup/ /net/departments/it/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/misc_backup /net/departments/it/		>>$LOG 2>&1

cp $CFLAGS /home/updates/SuperOfficeBackup/ /net/departments/it/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/SuperOfficeBackup /net/departments/it/		>>$LOG 2>&1

cp $CFLAGS /home/updates/TestLinkBackup/ /net/departments/it/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/TestLinkBackup /net/departments/it/		>>$LOG 2>&1

cp $CFLAGS /home/misc/Backup_Puno/ /net/departments/it/		>>$LOG 2>&1
rsync $RFLAGS /home/misc/Backup_Puno /net/departments/it/		>>$LOG 2>&1

cp $CFLAGS /home/misc/HjemmePC/ /net/departments/it/		>>$LOG 2>&1
rsync $RFLAGS /home/misc/HjemmePC /net/departments/it/		>>$LOG 2>&1

date >> $LOG
