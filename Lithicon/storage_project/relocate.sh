#!/bin/bash

TS="/net/projects/ts"
TSOLD="/home/technicalservices"

CP="cp -ru"
RS="rsync -lort --delete-after"

(
cp -a $TSOLD/Year2005/Org\ Ourhoud.doc $TS/Ourhoud/Y2005/

$CP $TSOLD/Year2005/RWE_DEA/* $TS/RWE_DEA/Y2005/
$RS $TSOLD/Year2005/RWE_DEA/ $TS/RWE_DEA/Y2005/

$CP $TSOLD/Year2005/Statoil/* $TS/StatoilHydro/Y2005/
$RS $TSOLD/Year2005/Statoil/ $TS/StatoilHydro/Y2005/

$CP $TSOLD/Year2005/ScannedTSimages/ $TS/unsorted/Year2005/
$RS $TSOLD/Year2005/ScannedTSimages $TS/unsorted/Year2005/

$CP $TSOLD/Year2006/Hydro/* $TS/StatoilHydro/Y2006/
$RS $TSOLD/Year2006/Hydro/ $TS/StatoilHydro/Y2006/

$CP $TSOLD/Year2006/Ourhoud/* $TS/Ourhoud/Y2006/
$RS $TSOLD/Year2006/Ourhoud/ $TS/Ourhoud/Y2006/

#$CP $TSOLD/Year2006/PDO/* $TS/PDO/Y2006/
#$RS $TSOLD/Year2006/PDO/ $TS/PDO/Y2006/

$CP $TSOLD/Year2006/RWE_DEA/* $TS/RWE_DEA/Y2006/
$RS $TSOLD/Year2006/RWE_DEA/ $TS/RWE_DEA/Y2006/

$CP $TSOLD/Year2006/SA/* $TS/SaudiAramco/Y2006/
$RS $TSOLD/Year2006/SA/ $TS/SaudiAramco/Y2006/

$CP $TSOLD/Year2006/Statoil/* $TS/StatoilHydro/Y2006/
$RS $TSOLD/Year2006/Statoil/ $TS/StatoilHydro/Y2006/

$CP $TSOLD/Year2006/Total/* $TS/Total/Y2006/
$RS $TSOLD/Year2006/Total/ $TS/Total/Y2006/

$CP $TSOLD/Year2007/BG_demo/* $TS/BritishGas/Y2007/
$RS $TSOLD/Year2007/BG_demo/ $TS/BritishGas/Y2007/

$CP $TSOLD/Year2007/Chevron/* $TS/Chevron-US/Y2007/
$RS $TSOLD/Year2007/Chevron/ $TS/Chevron-US/Y2007/

$CP $TSOLD/Year2007/ENI/* $TS/ENI/Y2007/
$RS $TSOLD/Year2007/ENI/ $TS/ENI/Y2007/

cp -a $TSOLD/Year2007/image_evaluation.zip $TS/unsorted/Year2007/

$CP $TSOLD/Year2007/Ourhoud/* $TS/Ourhoud/Y2007/
$RS $TSOLD/Year2007/Ourhoud/ $TS/Ourhoud/Y2007/

$CP $TSOLD/Year2007/PDO/* $TS/PDO/Y2007/
$RS $TSOLD/Year2007/PDO/ $TS/PDO/Y2007/

$CP $TSOLD/Year2007/Planning/* $TS/unsorted/Year2007/
$RS $TSOLD/Year2007/Planning/ $TS/unsorted/Year2007/

$CP $TSOLD/Year2007/Rocksource/* $TS/Rocksource/Y2007/
$RS $TSOLD/Year2007/Rocksource/ $TS/Rocksource/Y2007/

$CP $TSOLD/Year2007/RWE-DEA/* $TS/RWE_DEA/Y2007/
$RS $TSOLD/Year2007/RWE-DEA/ $TS/RWE_DEA/Y2007/

$CP $TSOLD/Year2007/Shell/* $TS/Shell/Y2007/
$RS $TSOLD/Year2007/Shell/ $TS/Shell/Y2007/

$CP $TSOLD/Year2007/Sonangol/* $TS/Sonangol/Y2007/
$RS $TSOLD/Year2007/Sonangol/ $TS/Sonangol/Y2007/

$CP $TSOLD/Year2007/Statoil/* $TS/StatoilHydro/Y2007/
$RS $TSOLD/Year2007/Statoil/ $TS/StatoilHydro/Y2007/

cp -a $TSOLD/Year2007/TS_2007.xls $TS/unsorted/Year2007/

$CP $TSOLD/Year2007/TS_Alex/ $TS/unsorted/Year2007/
$RS $TSOLD/Year2007/TS_Alex $TS/unsorted/Year2007/

$CP $TSOLD/Year2007/unidentified\ samples\ maybe\ Sn\øvhit/ $TS/unsorted/Year2007/
$RS $TSOLD/Year2007/unidentified\ samples\ maybe\ Sn\øvhit $TS/unsorted/Year2007/

$CP $TSOLD/Year2008/ChevronNorge/* $TS/Chevron-NO/Y2008/
$RS $TSOLD/Year2008/ChevronNorge/ $TS/Chevron-NO/Y2008/

$CP $TSOLD/Year2008/DetNorske/* $TS/DetNorske/Y2008/
$RS $TSOLD/Year2008/DetNorske/ $TS/DetNorske/Y2008/

$CP $TSOLD/Year2008/ENI/* $TS/ENI/Y2008/
$RS $TSOLD/Year2008/ENI/ $TS/ENI/Y2008/

$CP $TSOLD/Year2008/Lundin/* $TS/Lundin/Y2008/
$RS $TSOLD/Year2008/Lundin/ $TS/Lundin/Y2008/

$CP $TSOLD/Year2008/RWE/* $TS/RWE_DEA/Y2008/
$RS $TSOLD/Year2008/RWE/ $TS/RWE_DEA/Y2008/

$CP $TSOLD/Year2008/StatoilHydro/* $TS/StatoilHydro/Y2008/
$RS $TSOLD/Year2008/StatoilHydro/ $TS/StatoilHydro/Y2008/

$CP $TSOLD/Year2008/Woodside/* $TS/Woodside/Y2008/
$RS $TSOLD/Year2008/Woodside/ $TS/Woodside/Y2008/
) > /net/projects/ts/synchax.log 2>&1
