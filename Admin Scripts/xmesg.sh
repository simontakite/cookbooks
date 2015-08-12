#! /bin/sh
# #############################################################################

NAME_="xmesg"
HTML_="show specific X window message"
PURPOSE_="display an X window message on a regular basis"
SYNOPSIS_="$NAME_ [-hl] <n>s|m|h|d '<message to display>'"
REQUIRES_="standard GNU commands"
VERSION_="1.1"
DATE_="2004-03-14; last update: 2010-07-02"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="desk"
PLATFORM_="Linux"
SHELL_="bash"
DISTRIBUTE_="yes"

# #############################################################################
# This program is distributed under the terms of the GNU General Public License

# HISTORY:
# 2010-07-02 v1.1 - on my new Slackware 12.2 the ps command started complaining
#                   about using improper syntax, so I changed the "ps -aux" to "ps aux"



usage () {

    echo >&2 "$NAME_ $VERSION_ - $PURPOSE_
    Usage: $SYNOPSIS_
    Requires: $REQUIRES_
    Options:
    <n>s|m|h|d, an integer referring to seconds|minutes|hours|days; the time
    interval for how often to display the message
    '<message to display>', a single quoted message to display
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

# enabling extended globbing
shopt -s extglob

# option handling
case $1 in
    -h) usage ;;
    -l) more $0; exit 1 ;;
    +([0-9])[smhd] )

    [[ $2 ]] || { echo >&2 missing second argument, type $NAME_ -h for help; exit 1; }

    while :;do

        sleep ${1}
        # display windowed message if x is running
        ps aux | grep -q xinit
        [ $? = 0 ] && xmessage -center $2

    done ;;

    *) echo invalid or missing argument, type $NAME_ -h for help; exit 1 ;;

esac
