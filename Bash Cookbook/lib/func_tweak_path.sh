# cookbook filename: func_tweak_path

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Add a directory to the beginning or end of your path as long as it's not
# already present. Does not take into account symbolic links!
# Returns: 1 or sets the new $PATH
# Called like: add_to_path <directory> (pre|post)
function add_to_path {
    local location=$1
    local directory=$2

    # Make sure we have something to work with
    if [ -z "$location" -o -z "$directory" ]; then
        echo "$0:$FUNCNAME: requires a location and a directory to add" >&2
        echo "e.g. add_to_path pre /bin" >&2
        return 1
    fi

    # Make sure the directory is not relative
    if [ $(echo $directory | grep '^/') ]; then
        :echo "$0:$FUNCNAME: '$directory' is absolute" >&2
    else
        echo "$0:$FUNCNAME: can't add relative directory '$directory' to the \$PATH" >&2
        return 1
    fi

    # Make sure the directory to add actually exists
    if [ -d "$directory" ]; then
        : echo "$0:$FUNCNAME: directory exists" >&2
    else
        echo "$0:$FUNCNAME: '$directory' does not exist--aborting" >&2
        return 1
    fi

    # Make sure it's not already in the PATH
    if [ $(contains "$PATH" "$directory") ]; then
        echo "$0:$FUNCNAME: '$directory' already in \$PATH--aborting" >&2
    else
        :echo "$0:$FUNCNAME: adding directory to \$PATH" >&2
    fi

    # Figure out what to do
    case $location in
        pre*  ) PATH="$directory:$PATH" ;;
        post* ) PATH="$PATH:$directory" ;;
        *     ) PATH="$PATH:$directory" ;;
    esac

    # Clean up the new path, then set it
    PATH=$(clean_path $PATH)

} # end of function add_to_path


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Remove a directory from your path, if present.
# Returns: sets the new $PATH
# Called like: rm_from_path <directory>
function rm_from_path {
    local directory=$1

    # Remove all instances of $directory from $PATH
    PATH=${PATH//$directory/}

    # Clean up the new path, then set it
    PATH=$(clean_path $PATH)

} # end of function rm_from_path


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Remove leading/trailing or duplicate ':', remove duplicate entries
# Returns: echos the "cleaned up" path
# Called like: cleaned_path=$(clean_path $PATH)
function clean_path {
    local path=$1
    local newpath
    local directory

    # Make sure we have something to work with
    [ -z "$path" ] && return 1

    # Remove duplicate directories, if any
    for directory in ${path//:/ }; do
        contains "$newpath" "$directory" && newpath="${newpath}:${directory}"
    done

    # Remove any leading ':' separators
    # Remove any trailing ':' separators
    # Remove any duplicate ':' separators
    newpath=$(echo $newpath | sed 's/^:*//; s/:*$//; s/::/:/g')

    # Return the new path
    echo $newpath

} # end of function clean_path


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Determine if the path contains a given directory
# Return 1 if target is contained within pattern, 0 otherwise
# Called like: contains $PATH $dir
function contains {
    local pattern=":$1:"
    local target=$2

    # This will be a case-sensitive comparison unless nocasematch is set
    case $pattern in
        *:$target:* ) return 1;;
        *           ) return 0;;
    esac
} # end of function contains
