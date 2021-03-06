#! /bin/sh
# #############################################################################

NAME_="rootkitwr"
HTML_="wrapper for chkrootkit"
PURPOSE_="chkrootkit wrapper; designed to run at regular intervals"
SYNOPSIS_="$NAME_ [-hml]"
REQUIRES_="chkrootkit, GNU: grep, mail, xmessage"
VERSION_="1.0"
DATE_="2003-11-26; last update: 2004-05-12"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="sec"
PLATFORM_="Linux"
SHELL_="bash"
DISTRIBUTE_="yes"

# #############################################################################
# This program is distributed under the terms of the GNU General Public License

# ------------------------------------------- #
# user defined variables start
# ------------------------------------------- #

safe_chkrootkit=/mnt/floppy/bin/chkr/chkrootkit  # path to a tamper free location of chkrootkit
safe_grep=/mnt/floppy/bin/grep                   # path to a tamper free location of grep
safe_mail=/mnt/floppy/bin/nail                   # path to a tamper free location of mail
safe_xmessage=/mnt/floppy/bin/xmessage           # path to a tamper free location of xmessage
mail_to=root                                     # user email address

# ------------------------------------------- #
# user defined variables end
# ------------------------------------------- #

usage() {

    echo >&2 "$NAME_ $VERSION_ - $PURPOSE_
    Usage: $SYNOPSIS_
    Requires: $REQUIRES_
    Options:
    -h usage and options (help)
    -m manual
    -l list the script"

    exit 1

}

manual() { echo >&2 "

NAME

$NAME_ $VERSION_ - $PURPOSE_

SYNOPSIS

$SYNOPSIS_

DESCRIPTION

$NAME_ is a simple chkrootkit wrapper designed to run at regular intervals as
a cronjob or at boot time. Chkrootkit is a tool designed to detect rootkits
on Unix systems. It can be downloaded from www.chkrootkit.org. This wrapper
sends alert mail to a specified user and displays a security alert message
if a rootkit has been found.

    Before running the script, edit the User defined variables section at the
    beginning of the script.

    To improve security, all tools (grep, mail, chkrootkit..) and the script
    itself should be put on a media that can be write protected like a
    floppy. This will make tampering with the script and the tools
    it uses impossible - unless physicall access is gained. Make sure that the
    tools you will put on the media have not been compromised already. Get them
    from a safe source like your install CD or a trusted site.

    NOTE

    This script must be run as root.

    AUTHOR

    $AUTHOR_ Suggestions and bug reports are welcome.
    For updates and more scripts visit $URL_

    "; exit 1; }

    # signal trapping
    trap "exit 1" 1 2 3 15

    # local funcs

    chk_rootkit() {

        echo checking for rootkits...
        $safe_chkrootkit | $safe_grep -e INFECTED -e Vulnerable

        if [ $? = 0 ]; then

            echo -e \\a ${0}: SECURITY ALERT: possible rootkit infection detected!

            # display windowed message if x is running
            ps -aux | grep -q xinit
            [ $? = 0 ] && $safe_xmessage -center "SECURITY ALERT: possible rootkit infection detected!"

            # email alert message
            echo "message from ${0}: possible rootkit infection detected! Run ${safe_chkrootkit} to see which files are infected"\
            | $safe_mail -s "=== SECURITY ALERT: possible rootkit infection detected!" $mail_to

            exit 1

        fi

        exit 0

    }

    # option and arg handling
    [ $# -eq 0 ] && chk_rootkit

    case $1 in
        -h) help ;;
        -m) manual ;;
        -l) more $0 ;;
        *) echo "invalid argument, type "$NAME_ "-h for help"; exit 1 ;;

    esac
