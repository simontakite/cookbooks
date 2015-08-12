#!/bin/bash

# By torad 22.10.2010
# Sums the size of all files found by find

matches=0
size=0

for f in $(find "$@" -exec ls -l {} \;|awk {'print $5'});do
   size=$(($size + $f))
   let matches++
done

size_KB=$(($size/1024))
size_MB=$(($size/1024/1024))
size_GB=$(($size/1024/1024/1024))

echo "Number of matches: $matches."

if (( $size >= 1073741824 ));then
   echo "Total size: $size_GB gigs."
elif (( $size >= 1048576 ));then
   echo "Total size: $size_MB megs."
else
   echo "Total size: $size_KB K."
fi
