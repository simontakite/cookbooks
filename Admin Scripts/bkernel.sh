#! /bin/sh
# #############################################################################

NAME_="bkernel"
HTML_="compile linux kernel script"
PURPOSE_="build linux kernels 2.2.xx and 2.4.xx"
SYNOPSIS_="$NAME_ [-hml] -a|-b <kernel_version>"
REQUIRES_="standard GNU commands"
VERSION_="1.2"
DATE_="2002-05-17; last update: 2003-11-12"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="admin"
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
    -a <kernel_version>, build kernel with modules
    -b <kernel_version>, build kernel with no modules
    -h, usage and options (this help)
    -m, manual
    -l, see this script"
    exit 1
}

manual() { echo >&2 "

NAME

$NAME_ $VERSION_ - $PURPOSE_

SYNOPSIS

$SYNOPSIS_

DESCRIPTION

This script compiles the i386 architecture 2.2.xx and 2.4.xx linux kernels
assuming that the sources are located in /usr/src/linux. Although the kernel
does not need to be compiled as root, the script must be run as root to be
able to install modules and the kernel.

AUTHOR

$AUTHOR_ Suggestions and bug reports are welcome.
For updates and more scripts visit $URL_

"; exit 1; }

# local functions
kernel_modules () {

    cd /usr/src/linux && \
    make dep && make clean && make bzImage && make modules && make modules_install && \
    cp arch/i386/boot/bzImage /boot/vmlinuz-${1} && cp System.map /boot/System.map-${1} && \
    echo Done compiling linux kernel $1 with modules
    echo "don't forget to edit /etc/lilo.conf and run lilo"

}

kernel_no_modules () {

    cd /usr/src/linux && \
    make dep && make clean && make bzImage && \
    cp arch/i386/boot/bzImage /boot/vmlinuz-${1} && cp System.map /boot/System.map-${1} && \
    echo Done compiling linux kernel $1 with no modules
    echo "don't forget to edit /etc/lilo.conf and run lilo"

}

# args check
[ $# -eq 0 ] && { echo >&2 missing argument, type $NAME_ -h for help; exit 1; }

# args and options
while getopts hmla:b: options; do

    case $options in

        a) kernel_modules $OPTARG ;;
        b) kernel_no_modules $OPTARG ;;
        h) usage ;;
        m) manual ;;
        l) more $0; exit 1 ;;
        \?) echo invalid argument, type $NAME_ -h for help; exit 1 ;;

    esac

done
