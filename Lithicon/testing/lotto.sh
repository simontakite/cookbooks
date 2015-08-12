#!/bin/bash
# Lottolappgenerator

if [ -z $1 ];then
   rekker=10
else
   rekker=$1
fi

while (( $rekker > 0 ));do
   tall=7
   while (( $tall > 0  ));do
      unikttall=0
      while (( $unikttall == 0 ));do
         unikttall=1
         talleter=$(($(expr $RANDOM % 34)+1))
         for n in ${rekke[@]};do
            if (( $talleter == $n ));then
               unikttall=0
            fi
         done
      done
      rekke[$tall]=$talleter
      echo $talleter >> lottotemp
      let tall--
   done
   out=$(sort -g lottotemp)
   echo ${out[@]}
   rm lottotemp
   let rekker--
done
