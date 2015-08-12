#!/bin/bash

LOG="/net/projects/copyts.log"

#MODE=$1
#if [[ $MODE != "-u" ]]; then
#   unset MODE
#else
#   MODE="u"
#fi

CFLAGS="-ru"
RFLAGS="-lort --delete-after --ignore-errors"

date > $LOG

cp $CFLAGS /home/technicalservices/Year2005/ /net/projects/ts/				>>$LOG 2>&1
rsync $RFLAGS /home/technicalservices/Year2005 /net/projects/ts/			>>$LOG 2>&1

cp $CFLAGS /home/technicalservices/Year2006/ /net/projects/ts/				>>$LOG 2>&1
rsync $RFLAGS /home/technicalservices/Year2006 /net/projects/ts/			>>$LOG 2>&1

cp $CFLAGS /home/technicalservices/Year2007/ /net/projects/ts/				>>$LOG 2>&1
rsync $RFLAGS /home/technicalservices/Year2007 /net/projects/ts/			>>$LOG 2>&1

cp $CFLAGS /home/technicalservices/Year2008/ /net/projects/ts/				>>$LOG 2>&1
rsync $RFLAGS /home/technicalservices/Year2008 /net/projects/ts/			>>$LOG 2>&1

cp $CFLAGS /home/technicalservices/bin/ /net/projects/ts/				>>$LOG 2>&1
rsync $RFLAGS /home/technicalservices/bin /net/projects/ts/			>>$LOG 2>&1

cp $CFLAGS /home/technicalservices/Procedure/ /net/projects/ts/				>>$LOG 2>&1
rsync $RFLAGS /home/technicalservices/Procedure /net/projects/ts/			>>$LOG 2>&1

cp $CFLAGS /home/technicalservices/Templates/ /net/projects/ts/				>>$LOG 2>&1
rsync $RFLAGS /home/technicalservices/Templates /net/projects/ts/			>>$LOG 2>&1

cp $CFLAGS /home/misc/NewMod_Networks/ /net/projects/ts/StatoilHydro/Y2007/ 			>>$LOG 2>&1
rsync $RFLAGS /home/misc/NewMod_Networks /net/projects/ts/StatoilHydro/Y2007/ 			>>$LOG 2>&1

cp $CFLAGS /home/misc/Simones\ Cuttings/ /net/projects/ts/Simones_Cuttings 	>>$LOG 2>&1
rsync $RFLAGS /home/misc/Simones\ Cuttings/ /net/projects/ts/Simones_Cuttings/ 	>>$LOG 2>&1

cp $CFLAGS /home/misc/StatoilHydroNewNetworks/ /net/projects/ts/StatoilHydro/Y2008/ 		>>$LOG 2>&1
rsync $RFLAGS /home/misc/StatoilHydroNewNetworks /net/projects/ts/StatoilHydro/Y2008/ 		>>$LOG 2>&1

cp $CFLAGS /home/misc/Test\ Fons/ /net/projects/ts/Shell/Y2007/	 			>>$LOG 2>&1
rsync $RFLAGS /home/misc/Test\ Fons /net/projects/ts/Shell/Y2007/				>>$LOG 2>&1

cp $CFLAGS /home/projects/Rock_Sample_Inventory/ /net/projects/ts/		>>$LOG 2>&1
rsync $RFLAGS /home/projects/Rock_Sample_Inventory /net/projects/ts/		>>$LOG 2>&1

cp -a /home/projects/absperm_memory.xls /net/projects/ts/tools/
cp -a /home/projects/grain_size_scale.xls /net/projects/ts/tools/
cp -a /home/projects/phi_scale.* /net/projects/ts/tools/
cp -a /home/technicalservices/Comparison_Grids_Networks_Updated_June2008.xls /net/projects/ts/Procedure/

date >> $LOG
