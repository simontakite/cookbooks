# cookbook filename: func_shift_by

# Pop a given number of items from the top of a stack,
# such that you can then perform an action on whatever is left.
# Called like: shift_by <# to keep> <ls command, or whatever>
# Returns:  the remainder of the stack or list
#
# For example, list some objects, then keep only the top 10.
#
# It is CRITICAL that you pass the items in order with the objects to
# be removed at the top (or front) of the list, since all this function
# does is remove (pop) the number of entries you specify from the top
# of the list.
#
# You should experiment with echo before using rm!
#
# For example:
#      rm -rf $(shift_by $MAX_BUILD_DIRS_TO_KEEP $(ls -rd backup.2006*))
#
function shift_by {

# If $1 is zero or greater than $#, the positional parameters are
# not changed. In this case that is a BAD THING!
if (( $1 == 0 || $1 > ( $# - 1 ) )); then
   echo ''
else
   # Remove the given number of objects (plus 1) from the list.
   shift $(( $1 + 1 ))
   # Return whatever is left
   echo "$*"
 fi
}
