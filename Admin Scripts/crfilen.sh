#! /bin/sh
# #############################################################################

NAME_="crfilen"
HTML_="create file script"
PURPOSE_="create a file n bytes large"
SYNOPSIS_="$NAME_ [-hl] <n> <file>"
REQUIRES_="standard GNU commands"
VERSION_="1.0"
DATE_="2004-05-27; last update: 2004-06-14"
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
    <n>, an integer referring to the size of file in bytes
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

#  args check
[ $# -eq 2 ] || { echo >&2 ${NAME_}: invalid argument format, type $NAME_ -h for help; exit 1; }

# option handling
case $1 in
    -h) usage ;;
    -l) more $0; exit 1 ;;
    *[!0-9]*) echo >&2 ${NAME_}: the first argument must be an integer; exit 1 ;;
    #    -*) echo "invalid argument, type "$NAME_ "-h for help"; exit 1 ;;
esac

c=0
while (( $c != $1 ));do
    echo -n a >> "$2"
    ((c++))
done
