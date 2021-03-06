#! /bin/sh
# #############################################################################

NAME_="longl"
HTML_="long lines in file"
PURPOSE_="print name of the file that contains lines longer then n chars"
SYNOPSIS_="$NAME_ [-hl] <n> <file> [file...]"
REQUIRES_="standard GNU commands"
VERSION_="1.0"
DATE_="2004-06-07; last update: 2004-06-21"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="text"
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
    <n>, an integer referring to minimum characters per line
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

# enabling extended globbing
shopt -s extglob

# arg handling and execution
case $1 in

    -h) usage ;;
    -l) more $0; exit 1 ;;
    +([0-9])) # arg1 can only be an integer

    n=$1
    shift
    for a in "$@";do

        c=0
        IFS=\n
        while read line;do

            if (( ${#line} > $n ));then
                echo "chars: ${#line} line#: $c file: $a"
            fi
            ((c++))

        done < $a

    done ;;

    *) echo "invalid argument, type "$NAME_ "-h for help"; exit 1 ;;

esac
