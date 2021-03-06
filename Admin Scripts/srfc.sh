#! /bin/sh
# #############################################################################

NAME_="srfc"
HTML_="rfc search script"
PURPOSE_="search local rfc file for a string, highlight found strings"
SYNOPSIS_="$NAME_ [-hl] <n> <string>"
REQUIRES_="standard GNU commands"
VERSION_="1.1"
DATE_="2000-03-15; last update: 2004-12-27"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="misc"
PLATFORM_="Linux"
SHELL_="bash"
DISTRIBUTE_="yes"

# #############################################################################
# This program is distributed under the terms of the GNU General Public License

usage() {

    echo >&2 "$NAME_ $VERSION_ - $PURPOSE_
    Usage: $SYNOPSIS_
    Requires: $REQUIRES_
    Options:
    <n> an integer referring to the rfc file number
    <string> the string to search for
    -h usage and options (this help)
    -l list the script"

    exit 1
}

# path to local rfc dir
rfc=~/rfc

# args check
[ $# -eq 0 ] && { echo >&2 missing argument, type $NAME_ -h for help; exit 1; }

# enabling extended globbing
shopt -s extglob

# arg handling and execution
case $1 in

    -h) usage ;;
    -l) more $0; exit 1 ;;
    +([0-9])) # main execution

    [ -f $rfc/rfc${1}.txt ] || { echo >&2 file $rfc/rfc${1}.txt does not exist; exit 1; }
    [ $2 ] || { echo >&2 missing second argument, type $NAME_ -h for help; exit 1; }
    grep -iC 5 --color=always $2 $rfc/rfc${1}.txt | more
    [[ ${PIPESTATUS[0]} != 0 ]] && { echo >&2 string \"$2\" not found in $rfc/rfc${1}.txt; exit 1; }
    ;;

    *) echo invalid or missing argument, type $NAME_ -h for help ; exit 1 ;;
esac
