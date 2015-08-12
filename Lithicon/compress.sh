#!/bin/bash

# --------------------------------------------------------------------- #
# compress.sh by torad                                                  #
# --------------------------------------------------------------------- #
# Created:      03.04.2008                                              #
# Changed:      24.03.2011                                              #
# Type:         Cron - utility                                          #
# --------------------------------------------------------------------- #
# Purpose:                                                              #
# - Find big files which haven't been accessed lately and gzip them.    #
# --------------------------------------------------------------------- #

fsize="+1G"     # Only files $fsize or bigger
fatime="+375"   # Only files not accessed the past $fatime days

[ -z "$1" ] && fpath=$(pwd) || fpath=$1
find $fpath/* \( -iname "*.bin" -or -iname "*.txt" -or -iname "*.dat" -or -iname "*.bin.raw" \) -size $fsize -atime $fatime -exec gzip -v {} \;
