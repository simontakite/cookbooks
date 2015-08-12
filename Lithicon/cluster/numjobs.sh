#!/bin/bash
export PATH=${PATH}:/opt/gridengine/bin/lx26-amd64/
export SGE_ROOT=/opt/gridengine
export SGE_QMASTER_PORT=536
LOGFILE=/var/log/numjobs.log
(
echo "----------------------------------"
date
echo 'Number of running jobs: ' $(qstat -s r | grep all.q | wc -l) 
echo 'Number of queued jobs: ' $(qstat -s p | grep qw | wc -l)
)>>$LOGFILE
