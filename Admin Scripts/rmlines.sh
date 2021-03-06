#! /bin/sh
# #############################################################################

NAME_="rmlines"
HTML_="delete words script"
PURPOSE_="remove lines that contain words stored in a list"
SYNOPSIS_="$NAME_ [-hl] -i <word_list> -o <file>"
REQUIRES_="standard GNU commands"
VERSION_="1.0"
DATE_="2004-06-19; last update: 2004-06-21"
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
    -i, file with words to remove
    -o, file from which to remove the words
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

# args check
[ $# -eq 0 ] && { echo >&2 missing argument, type $NAME_ -h for help; exit 1; }

# tmp file set up
tmp_1=/tmp/tmp.${RANDOM}$$

# signal trapping and tmp file removal
trap 'rm -f $tmp_1 >/dev/null 2>&1' 0
trap "exit 1" 1 2 3 15

# option and arg handling
while getopts hli:o: options; do

    case $options in

        i) inputf=$OPTARG ;;
        o) outputf=$OPTARG ;;
        h) usage ;;
        l) more $0; exit 1 ;;
        \?) echo invalid argument, type $NAME_ -h for help; exit 1 ;;

    esac

done
shift $(( $OPTIND - 1 ))

# file arg check
if [ ! $inputf ] || [ ! $outputf ]; then
    echo missing argument, type $NAME_ -h for help
    exit 1
fi

# main
sed -e 's/ //g' -e 's-^-/-g' -e 's-$-/d-' $inputf > $tmp_1
sed -f $tmp_1 $outputf
