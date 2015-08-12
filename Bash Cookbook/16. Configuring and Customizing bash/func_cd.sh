# cookbook filename: func_cd

# Allow use of 'cd ...' to cd up 2 levels, 'cd ....' up 3, etc. (like 4NT/4DOS)
# Usage: cd ..., etc.
function cd {

    local option= length= count= cdpath= i= # Local scope and start clean

    # If we have a -L or -P sym link option, save then remove it
    if [ "$1" = "-P" -o "$1" = "-L" ]; then
        option="$1"
        shift
    fi

    # Are we using the special syntax? Make sure $1 isn't empty, then
    # match the first 3 characters of $1 to see if they are '...' then
    # make sure there isn't a slash by trying a substitution; if it fails,
    # there's no slash. Both of these string routines require Bash 2.0+
    if [ -n "$1" -a "${1:0:3}" = '...' -a "$1" = "${1%/*}" ]; then
        # We are using special syntax
        length=${#1}  # Assume that $1 has nothing but dots and count them
        count=2       # 'cd ..' still means up one level, so ignore first two

        # While we haven't run out of dots, keep cd'ing up 1 level
        for ((i=$count;i<=$length;i++)); do
            cdpath="${cdpath}../" # Build the cd path
        done

        # Actually do the cd
        builtin cd $option "$cdpath"
    elif [ -n "$1" ]; then
        # We are NOT using special syntax; just plain old cd by itself
        builtin cd $option "$*"
    else
        # We are NOT using special syntax; plain old cd by itself to home dir
        builtin cd $option
    fi
} # end of cd
