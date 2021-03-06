#! /bin/sh
# #############################################################################

NAME_="subspace"
HTML_="remove spaces in files"
PURPOSE_="substitute space in a file and dir name with an _"
SYNOPSIS_="$NAME_ [-vhl] <file> [file...]"
REQUIRES_="standard GNU commands"
VERSION_="1.4"
DATE_="1998-11-20; last update: 2004-02-08"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="file"
PLATFORM_="Linux"
SHELL_="bash"
DISTRIBUTE_="yes"

# #############################################################################
# This program is distributed under the terms of the GNU General Public License

usage () {

    echo >&2 "$NAME_ $VERSION_ - $PURPOSE_
    Usage: $SYNOPSIS_
    Requires: $REQUIRES_
    Options:
    -v, verbose
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

# args check
[ $# -eq 0 ] && { echo >&2 missing argument, type $NAME_ -h for help; exit 1; }

# var init
verbose=

# option and arg handling
while getopts vhlr options; do

    case "$options" in
        v) verbose=on ;;
        h) usage ;;
        l) more $0; exit 1 ;;
        \?) echo invalid argument, type $NAME_ -h for help; exit 1 ;;
    esac

done
shift $(( $OPTIND - 1 ))

# main execution
for a in "$@"; do

    newf=${a// /_}
    if [[ "$a" == "$newf" ]];then
        continue # no spaces in file name
    elif [ -f "$newf" ] || [ -d "$newf" ]; then
        echo "${NAME_}: not renaming \"$a\" - \"$newf\" already exist" && continue
    else
        mv -- "$a" "$newf"
        [[ $verbose ]] && echo "renaming: \"$a\" -> \"$newf\""
    fi

done
