#!/bin/bash

LOG="/net/software/sw.log"

#MODE=$1
#if [[ $MODE != "-u" ]]; then
#   unset MODE
#else
#   MODE="u"
#fi

CFLAGS="-ru"
RFLAGS="-lort --delete-after"

date > $LOG

cp $CFLAGS /home/misc/RPMs/ /net/software/       >>$LOG 2>&1
rsync $RFLAGS /home/misc/RPMs /net/software/     >>$LOG 2>&1

cp $CFLAGS /home/updates/ecore*	/net/software/e-Core/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/ecore* /net/software/e-Core/	>>$LOG 2>&1

cp $CFLAGS /home/updates/Ecore*	/net/software/e-Core/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/Ecore* /net/software/e-Core/	>>$LOG 2>&1

cp $CFLAGS /home/updates/programs/ecore/ /net/software/e-Core/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/programs/ecore /net/software/e-Core/	>>$LOG 2>&1

cp $CFLAGS /home/updates/programs/CLUE/	/net/software/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/programs/CLUE /net/software/	>>$LOG 2>&1

cp -u /home/updates/PathScale-Compiler* /net/software/RPMs/apps/pathscale/
cp -u /home/updates/pscsubscription-Compiler-3922.xml /net/software/RPMs/apps/pathscale/

cp $CFLAGS /home/misc/ecore-1.3/ /net/software/e-Core/		>>$LOG 2>&1
rsync $RFLAGS /home/updates/ecore-1.3 /net/software/e-Core/	>>$LOG 2>&1

cp $CFLAGS /home/misc/ecore-1.3.1/ /net/software/e-Core/	>>$LOG 2>&1
rsync $RFLAGS /home/updates/ecore-1.3.1 /net/software/e-Core/	>>$LOG 2>&1

date >> $LOG
