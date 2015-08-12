#!/bin/bash

for jobdir in $(ls -l|grep ^d|awk '{print $9}');do
   (( $(ls -l $jobdir|grep -c .out) == 0 )) && echo $jobdir
done
