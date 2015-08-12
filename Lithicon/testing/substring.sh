#!/bin/bash

in=$1

if [[ "${in:0:1}" == "0"  ]];then
   in="x${in:1}"
fi

echo $in
