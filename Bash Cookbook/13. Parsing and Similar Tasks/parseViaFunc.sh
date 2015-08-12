#!/usr/bin/env bash
# cookbook filename: parseViaFunc
#
# parse ls -l via function call
# an example of output from ls -l follows:
# -rw-r--r--  1 albing users 126 2006-10-10 22:50 fnsize

function lsparts ()
{
    PERMS=$1
    LCOUNT=$2
    OWNER=$3
    GROUP=$4
    SIZE=$5
    CRDATE=$6
    CRDAY=$7
    CRTIME=$8
    FILE=$9
}

lsparts $(ls -l "$1")

echo $FILE has $LCOUNT 'link(s)' and is $SIZE bytes long.
