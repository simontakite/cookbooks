#!/bin/bash
sleepz=0
while [ -f /tmp/sov ];do
   if (( $sleepz == 0 ));then
      echo "Zzzzz..... zzzz....."
   else
      echo "Zzzzz..... I've been sleeping for $sleepz seconds."
   fi
   sleep 5
   let sleepz+=5
done

echo -n "I'm alive"
(( $sleepz != 0 )) && echo -n " after $sleepz seconds of sleep"
echo "!"
