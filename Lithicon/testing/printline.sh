#!/bin/bash
# Print line l in file f
l=$1
f=$2
sed -n "$l s/.*/&/p" < $f
