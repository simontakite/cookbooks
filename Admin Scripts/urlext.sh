#! /bin/sh
# #############################################################################

NAME_="urlext"
HTML_="isolate url link"
PURPOSE_="extract url addresses from file or stdin"
SYNOPSIS_="$NAME_ [-hl] [-t <file> file...] <file> [file...]"
REQUIRES_="standard GNU commands"
VERSION_="1.2"
DATE_="2002-07-16; last update: 2004-05-21"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="www"
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
    -t file, extract urls from file and convert to html links <a href=url>url</a>
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

# tmp file set up
tmp_1=/tmp/tmp.${RANDOM}$$

# signal trapping and tmp file removal
trap 'rm -f $tmp_1 >/dev/null 2>&1' 0
trap "exit 1" 1 2 3 15

# init vars
tags=

# option and argument handling
case $1 in
    -t) tags=on; shift ;;
    -h) usage ;;
    -l) more $0 ; exit 1 ;;
    *) tags=off ;;
esac

# main
args=$@
cat "$@" | { # so we can act as a filter

tr '<>"\47 ' '[\n*]' | sed -n -e 's/href=//gI' -e 's/src=//gI' -e '/http:/Ip' > $tmp_1

if [[ $tags == on ]]; then

    echo "<html><head><title>URLs extracted from: "${args}"</title></head><body>"
    while read line; do
        echo "<a href=\""${line}\"">"${line}"</a><br>"
    done < $tmp_1
    echo "</body></html>"

else

    cat $tmp_1

fi
}
