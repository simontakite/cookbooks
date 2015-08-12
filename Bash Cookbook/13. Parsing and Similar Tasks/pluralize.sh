#!/usr/bin/env bash
# cookbook filename: pluralize
#
# A function to make words plural by adding an s
# when the value ($2) is != 1 or -1
# It only adds an 's'; it is not very smart.
#
function plural ()
{
    if [ $2 -eq 1 -o $2 -eq -1 ]
    then
        echo ${1}
    else
        echo ${1}s
    fi
}

while read num name
do
    echo $num $(plural "$name" $num)
done
