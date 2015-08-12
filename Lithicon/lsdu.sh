#!/bin/bash

[[ -d $1 ]] && dir=$1 || dir=$(pwd)

subdirs=$(ls -Al $dir|awk {'print $9'}|grep -v '.snapshot')


for i in ${subdirs[*]};do
   if [[ -d $dir/$i ]]; then
      echo -n $(ls -ld $dir/$i|awk {'print $3'})
      echo -e '\t' $(du -sh $dir/$i)
   fi
done|sort
