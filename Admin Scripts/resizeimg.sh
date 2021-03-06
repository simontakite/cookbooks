#! /bin/sh
# #############################################################################

NAME_="resizeimg"
HTML_="batch resize images"
PURPOSE_="resize bitmap image"
SYNOPSIS_="$NAME_ [-hlv] -w <n> <file> [file...]"
REQUIRES_="standard GNU commands, ImageMagick"
VERSION_="1.2"
DATE_="2001-04-22; last update: 2004-10-02"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="gfx"
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
    -w <n>, an integer referring to width in pixels; aspect ratio will be preserved
    -v, verbose
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

gfx_resizeImage() {

    # arg check
    [[ $1 == *[!0-9]* ]] && { echo >&2 $1 must be an integer; exit 1; }
    [ ! -f $2 ] && { echo >&2 file $2 not found; continue ;}

    # scaling down to value in width
    mogrify -geometry $1 $2

}

# args check
[ $# -eq 0 ] && { echo >&2 missing argument, type $NAME_ -h for help; exit 1; }

# var init
verbose=
width=

# option and arg handling
while getopts vhlw: options; do

    case $options in
        v) verbose=on ;;
        w) width=$OPTARG ;;
        h) usage ;;
        l) more $0; exit 1 ;;
        \?) echo invalid argument, type $NAME_ -h for help; exit 1 ;;
    esac

done
shift $(( $OPTIND - 1 ))

# check if required command is in $PATH variable
which mogrify &> /dev/null
[[ $? != 0 ]] && { echo >&2 the required ImageMagick \"mogrify\" command \
is not in your PATH variable; exit 1; }

for a in "$@";do

    gfx_resizeImage $width $a
    [[ $verbose ]] && echo ${NAME_}: $a

done
