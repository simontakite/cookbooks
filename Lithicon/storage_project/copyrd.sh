#!/bin/bash

LOG="/net/projects/copyrd.log"

#MODE=$1
#if [[ $MODE != "-u" ]]; then
#   unset MODE
#else
#   MODE="u"
#fi

CFLAGS="-ru"
RFLAGS="-lort --delete-after"

date > $LOG

cp $CFLAGS /home/projects/Berea/ /net/projects/rd/ 		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Berea /net/projects/rd/ 		>>$LOG 2>&1

cp $CFLAGS /home/projects/eCarbonates/ /net/projects/rd/ 	>>$LOG 2>&1
rsync $RFLAGS /home/projects/eCarbonates /net/projects/rd/ 	>>$LOG 2>&1

cp $CFLAGS /home/projects/eConcrete/ /net/projects/rd/ 		>>$LOG 2>&1
rsync $RFLAGS /home/projects/eConcrete /net/projects/rd/ 	>>$LOG 2>&1

cp $CFLAGS /home/projects/Fontainebleau/ /net/projects/rd/ 	>>$LOG 2>&1
rsync $RFLAGS /home/projects/Fontainebleau /net/projects/rd/ 	>>$LOG 2>&1

cp $CFLAGS /home/projects/InternalProjects/ /net/projects/rd/ 	>>$LOG 2>&1
rsync $RFLAGS /home/projects/InternalProjects /net/projects/rd/ >>$LOG 2>&1

cp $CFLAGS /home/projects/Luc/ /net/projects/rd/ 		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Luc /net/projects/rd/ 		>>$LOG 2>&1

cp $CFLAGS /home/projects/Petromaks/ /net/projects/rd/ 		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Petromaks /net/projects/rd/ 	>>$LOG 2>&1

cp $CFLAGS /home/projects/Petrusca/ /net/projects/rd/ 		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Petrusca /net/projects/rd/ 	>>$LOG 2>&1

cp $CFLAGS /home/projects/StatoilData/ /net/projects/rd/ 	>>$LOG 2>&1
rsync $RFLAGS /home/projects/StatoilData /net/projects/rd/ 	>>$LOG 2>&1

cp $CFLAGS /home/projects/StatoilProjects/ /net/projects/rd/ 	>>$LOG 2>&1
rsync $RFLAGS /home/projects/StatoilProjects /net/projects/rd/ 	>>$LOG 2>&1

cp $CFLAGS /home/projects/Systematic_study/ /net/projects/rd/ 	>>$LOG 2>&1
rsync $RFLAGS /home/projects/Systematic_study /net/projects/rd/ >>$LOG 2>&1

cp $CFLAGS /home/misc/eCuttings/ /net/projects/rd/ 		>>$LOG 2>&1
rsync $RFLAGS /home/misc/eCuttings /net/projects/rd/ 		>>$LOG 2>&1

cp $CFLAGS /home/projects/3-Phase/ /net/projects/rd/	 	>>$LOG 2>&1
rsync $RFLAGS /home/projects/3-Phase /net/projects/rd/	 	>>$LOG 2>&1

cp $CFLAGS /home/projects/3PhaseProject/ /net/projects/rd/ 	>>$LOG 2>&1
rsync $RFLAGS /home/projects/3PhaseProject /net/projects/rd/ 	>>$LOG 2>&1

cp $CFLAGS /home/projects/Skattefunn/ /net/projects/rd/ 	>>$LOG 2>&1
rsync $RFLAGS /home/projects/Skattefunn /net/projects/rd/ 	>>$LOG 2>&1

date >> $LOG
