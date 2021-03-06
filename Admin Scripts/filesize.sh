#! /bin/sh
# #############################################################################

NAME_="filesize"
HTML_="print size of files"
PURPOSE_="print sum of the actual size of files"
SYNOPSIS_="$NAME_ [-hld] <file> [file...]"
REQUIRES_="standard GNU commands"
VERSION_="1.2"
DATE_="2002-03-07; last update: 2004-02-15"
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
    -d, print sum of actual size dot delimited
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

# local funcs
string_intDelim () {
    echo $1 | sed '{ s/$/@/; : loop; s/\(...\)@/@.\1/; t loop; s/@//; s/^\.//; }'
}

# arg check
[ $# -eq 0 ] && { echo >&2 missing argument, type $NAME_ -h for help; exit 1; }

# var init
t=0
delimit=

# arg handling and execution
case "$1" in

    -h) usage ;;
    -l) more $0; exit 1 ;;
    *) # main execution

    [[ "$1" == -d ]] && { delimit=on; shift; }

    for a in "$@";do
        if [ -f "$a" ]; then
            s=$(set -- $(ls -l "$a"); echo $5)
            ((t+=s))
        else
            echo file "$a" does not exist
        fi
    done ;;

esac

[ $delimit ] && { echo $(string_intDelim $t); } || echo $t
