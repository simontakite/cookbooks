# cookbook filename: func_split

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Output fixed-size pieces of input ONLY if the limit is exceeded
# Called like: Split <file> <prefix> <limit option> <limit argument>
# e.g. Split $output ${output}_ --lines 100
# See split(1) and wc(1) for option details
function Split {
    local file=$1
    local prefix=$2
    local limit_type=$3
    local limit_size=$4
    local wc_option

    # Sanity Checks
    if [ -z "$file" ]; then
        printf "%b" "Split: requires a file name!\n"
        return 1
    fi
    if [ -z "$prefix" ]; then
        printf "%b" "Split: requires an output file prefix!\n"
        return 1
    fi
    if [ -z "$limit_type" ]; then
        printf "%b" "Split: requires a limit option (e.g. --lines), see 'man split'!\n"
        return 1
    fi
    if [ -z "$limit_size" ]; then
        printf "%b" "Split: requires a limit size (e.g. 100), see 'man split'!\n"
        return 1
    fi

    # Convert split options to wc options. Sigh.
    # Not all options supported by all wc/split on all systems
    case $limit_type in
        -b|--bytes)      wc_option='-c';;
        -C|--line-bytes) wc_option='-L';;
        -l|--lines)      wc_option='-l';;
    esac

    # If whatever limit is exceeded
    if [ "$(wc $wc_option $file | awk '{print $1}')" -gt $limit_size ]; then
        # actually do something
        split --verbose $limit_type $limit_size $file $prefix
    fi
} # end of function Split
