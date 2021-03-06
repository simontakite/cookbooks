#! /bin/sh
# #############################################################################

NAME_="word2txt"
HTML_="convert doc to text"
PURPOSE_="display ms word doc file in ascii format"
SYNOPSIS_="$NAME_ [-hl] <doc_file> [doc_file...]"
REQUIRES_="standard GNU commands, catdoc"
VERSION_="1.0"
DATE_="2004-07-22; last update: 2004-07-22"
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
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

# missing args check
[ $# -eq 0 ] && { echo >&2 missing argument, type $NAME_ -h for help; exit 1; }

# arg handling and main script execution
case $1 in

    -h) usage ;;
    -l) more $0; exit 1 ;;
    *) # main script execution

    # check if required command is in $PATH variable
    which catdoc &> /dev/null
    [[ $? != 0 ]] && { echo >&2 the needed \"catdoc\" command is not in your PATH; exit 1; }

    for a in $@;do
        catdoc -b -s cp1252 -d 8859-1 -a $1
    done ;;

esac
