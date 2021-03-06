#! /bin/sh
# #############################################################################

NAME_="zipfile"
HTML_="zip file script"
PURPOSE_="zip a single file"
SYNOPSIS_="$NAME_ [-hl] [-r] <file> [file...]"
REQUIRES_="standard GNU commands, zip"
VERSION_="1.1"
DATE_="1998-12-17; last update: 2004-12-23"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="compress"
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
    -r, remove the input file after conversion
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

# args check
[ $# -eq 0 ] && { echo >&2 missing argument, type $NAME_ -h for help; exit 1; }

# var init
rm_input=

# option and arg handling
while getopts hlr options; do

    case $options in
        r) rm_input=on ;;
        h) usage ;;
        l) more $0; exit 1 ;;
        \?) echo invalid argument, type $NAME_ -h for help; exit 1 ;;
    esac

done
shift $(( $OPTIND - 1 ))

# main execution
for a in "$@"; do

    if [ -f ${a}.[zZ][iI][pP] ] || [[ ${a##*.} == [zZ][iI][pP] ]]; then
        { echo skipping $a - already zipped; continue; }
    else
        [ -f $a ] && zip -9 ${a}.zip $a || { echo file $a does not exist; continue ;}
        [[ $rm_input ]] && rm -f -- $a
    fi

done
