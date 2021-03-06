#! /bin/sh
# #############################################################################

NAME_="sfiles"
HTML_="find strings in files"
PURPOSE_="recursively search files for strings; list found files in sorted order"
SYNOPSIS_="$NAME_ [-hlm] -p \"<pattern>\" -s +|-<n> -a \"<string [string..]>\" [-o \"<string [string..]>\"] [-n \"<string [string..]>\"]"
REQUIRES_="standard GNU commands"
VERSION_="1.1"
DATE_="2002-06-17; last update: 2005-02-14"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="file"
PLATFORM_="Linux"
SHELL_="bash"
DISTRIBUTE_="yes"

# #############################################################################
# This program is distributed under the terms of the GNU General Public License

# HISTORY:
# 2002-06-17 v1.0
# 2005-02-14 v1.1 - complete rewrite

# TODO:
# - change the file searching arguments to one find argument


usage () {

    echo >&2 "$NAME_ $VERSION_ - $PURPOSE_
    Usage: $SYNOPSIS_
    Requires: $REQUIRES_
    Options:
    -p, \"<pattern>\", search file pattern as accepted by find's -name option.
    No case distinction is made.
    -s, +|-<n>, file size in bytes; +n for greater then n; -n for less then n;
    n for exactly n.
    -a, AND operator. Match files that contain all strings supplied to this
    argument. No case distinction is made.
    -o, OR operator. Match files that contain at least one of the strings
    supplied to this argument. No case distinction is made.
    -n, NOT operator. Do not match files that contain strings supplied to this
    argument. No case distinction is made.
    -w, list files in html format, where each file has a link to it's location
    -h, usage and options (this help)
    -m, manual
    -l, see this script"
    exit 1
}

manual () { echo >&2 "

NAME

$NAME_ $VERSION_ - $PURPOSE_

SYNOPSIS

$SYNOPSIS_

DESCRIPTION

$NAME_ is a searching tool for local text files. It recursively searches for
specified strings in files. It supports AND, OR and NOT boolean operators.
The string search is not case sensitive. The output consists of the sum of
each string found in a matched file. The results are sorted by the total AND
strings found. An html formatted output is optional for easy location of
files using a browser.

AUTHOR

$AUTHOR_ Suggestions and bug reports are welcome.
For updates and more scripts visit $URL_

"; exit 1; }

# args check
[ $# -eq 0 ] && { echo >&2 missing argument, type $NAME_ -h for help; exit 1; }

# tmp file set up
tmp_dir=/tmp/${RANDOM}${RANDOM}
mkdir $tmp_dir
tmp_1=$tmp_dir/tmp.${RANDOM}${RANDOM}

# signal trapping and tmp file removal
trap 'rm -f $tmp_1; rmdir $tmp_dir >/dev/null 2>&1' 0
trap "exit 1" 1 2 3 15

# var init
file_size=
file_pattern=
and_strings=
or_strings=
not_strings=
html_format=
html_header=

while getopts whlms:p:a:o:n: options; do

    case "$options" in
        s) file_size=$OPTARG ;;
        p) file_pattern=$OPTARG ;;
        a) and_strings=($OPTARG) ;;
        o) or_strings=($OPTARG) ;;
        n) not_strings=($OPTARG) ;;
        w) html_format=on ;;
        h) usage ;;
        m) manual | more; exit 1 ;;
        l) more $0; exit 1 ;;
        \?) echo invalid argument, type $NAME_ -h for help; exit 1 ;;

    esac

done
args=$@
shift $(( $OPTIND - 1 ))

# arg check
[[ $file_pattern ]] || { echo >&2 missing file pattern argument; exit 1; }
[[ $file_size ]] || { echo >&2 missing file size argument; exit 1; }
[[ $and_strings ]] || { echo >&2 missing option to the -a argument; exit 1; }

# main
find . -type f -iname "${file_pattern}" -size ${file_size}c | while read file; do

    # searching for AND strings
    c=0
    total_count=0
    for string in ${and_strings[*]}; do

        count=$(grep -ci $string $file)
        [ $? != 0 ] && continue 2
        result[c]=$(echo ${string}: $count)
        ((c++))
        (( total_count += count ))
    done

    # if OR strings are set
    if [[ $or_strings ]];then

        # search for OR strings
        for string in ${or_strings[*]}; do

            grep -qi $string $file
            [ $? = 0 ] && or=0 || or=1

        done

        [[ $or == 1 ]] && continue

    fi

    # if NOT strings are set
    if [[ $not_strings ]]; then

        # search for NOT strings
        for string in ${not_strings[*]}; do

            grep -qi $string $file
            [ $? = 0 ] && continue 2

        done

    fi

    # printing files that match the search criteria
    if [[ $html_format ]];then

        if [[ $html_header ]]; then

            echo "total:<b> $total_count </b> ${result[*]} file: <a href=\"$file\">$file</a><br>" >> $tmp_1

        else

            echo "<html><head><title>$args $(pwd)</title></head><body>"
            echo "<b>dir:</b> $(pwd)<br>"
            echo "<b>arg:</b> $args<br><hr>"
            echo "<b>search results:</b><br><br>"
            echo "total:<b> $total_count </b> ${result[*]} file: <a href=\"$file\">$file</a><br>" >> $tmp_1
            html_header=0

        fi

    else

        echo total: $total_count ${result[*]} file: $file >> $tmp_1

    fi

done

sort -grk 2 $tmp_1
