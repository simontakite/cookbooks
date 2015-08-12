#!/usr/bin/env bash
# cookbook filename: rpncalc
#
# simple RPN command line (integer) calculator
#
# takes the arguments and computes with them
# of the form a b op
# allow the use of x instead of *
#
# error check our argument counts:
if [ \( $# -lt 3 \) -o \( $(($# % 2)) -eq 0 \) ]
then
    echo "usage: calc number number op [ number op ] ..."
    echo "use x or '*' for multiplication"
    exit 1
fi

ANS=$(($1 ${3//x/*} $2))
shift 3
while [ $# -gt 0 ]
do
    ANS=$((ANS ${2//x/*} $1))
    shift 2
done
echo $ANS
