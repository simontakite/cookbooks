#!/bin/bash

# ----------------------------------------------------- #
# check_dbdump.sh by torad      last edit: 21.07.2009   #
# ----------------------------------------------------- #
# Do:                                                   #
# - Check whether database dump files are up to date    #
# Relies on:                                            #
# - /net/departments being mounted                      #
# ----------------------------------------------------- #

# Sensitivity (find -mtime value)
modOpt="+1"

# Make sure departments is mounted
if ! grep -q departments /proc/mounts;then
   exitcode=3
   exitstatus="UNKNOWN"
   errorinfo="/net/departments not mounted"
else
   # Make sure the dumpfiles are found, and count them
   dumps=$(ls -l /net/departments/it/misc_backup/dbdump/*/*|wc -l)
   if (( $dumps == 0 ));then
      exitcode=3
      exitstatus="UNKNOWN"
      errorinfo="No dumps found. Check permissions"
   else
      # Find dumps not updated in more than 24 hours
      count=0
      for dump in $(find /net/departments/it/misc_backup/dbdump/*/* -mtime $modOpt|cut -d "/" -f7,8);do
         if (( $count == 0 ));then
            oldfiles+="$dump"
         else
            oldfiles+=", $dump"
         fi
         let count++
      done
      if (( $count != 0 ));then
         exitcode=1
         exitstatus="WARNING"
         if (( $count > 1 ));then s="s";else s="";fi
         errorinfo="$count outdated dump$s: $oldfiles"
      else
         exitcode=0
         exitstatus="OK"
         errorinfo="$dumps dumps up to date"
      fi
   fi
fi

echo "$exitstatus - $errorinfo."
exit $exitcode
