#!/usr/bin/env bash
# cookbook filename: chmod_all.2
#
# change permissions on a bunch of files
# with better quoting in case of filenames with blanks
#
for FN in "$@"
do
    chmod 0750 "$FN"
done
