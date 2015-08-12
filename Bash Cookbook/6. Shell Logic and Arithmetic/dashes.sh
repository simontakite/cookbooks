#!/usr/bin/env bash
# cookbook filename: dashes
#
# dashes - print a line of dashes
#
# options: # how many (default 72)
# -c X use char X instead of dashes
#

LEN=72
CHAR='-'
while (( $# > 0 ))
do
    case $1 in
        [0-9]*) LEN=$1
            ;;
        -c) shift;
               CHAR=${1:--}
            ;;
        *) printf 'usage: %s [-c X] [#]\n' $(basename $0) >&2
            exit 2
            ;;
    esac
     shift
done
#
# more...
