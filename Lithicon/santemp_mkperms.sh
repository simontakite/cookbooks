#!/bin/bash

[ ! -d "$1" ] && echo "Usage: $0 <dir>." && exit 1

mydir=$1
acl_template=/net/temp/tor

chmod 2775 $mydir
getfacl -d $acl_template|setfacl -d -M- $mydir

exit 0
