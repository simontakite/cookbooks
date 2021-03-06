#! /bin/sh
# #############################################################################

NAME_="whichbin"
HTML_="locate binary executable"
PURPOSE_="show links and path to executable"
SYNOPSIS_="$NAME_ [-hl] <executable> [executable...]"
REQUIRES_="standard GNU commands"
VERSION_="1.0"
DATE_="2004-07-11; last update: 2004-07-11"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="sys"
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
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

# args check
[ $# -eq 0 ] && { echo >&2 missing argument, type $NAME_ -h for help; exit 1; }

follow_link() {

    file=$(which $1)
    [ $? != 0 ] && { echo >&2 $1 not an executable ; exit 1; }
    if [ -L $file ];then
        echo symlink $file
        cd $(dirname $file)
        follow_link $(set -- $(ls -l $1); shift 10; echo $1)
    else
        ls -l $file
    fi

}

# arg handling and main execution
case $1 in

    -h) usage ;;
    -l) more $0; exit 1 ;;
    *) # main execution

    for a in $@;do
        follow_link $a
    done ;;

esac
