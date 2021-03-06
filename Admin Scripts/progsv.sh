#! /bin/sh
# #############################################################################

NAME_="progsv"
HTML_="show program version"
PURPOSE_="list version numbers of important programs installed"
SYNOPSIS_="$NAME_ [-hl]"
REQUIRES_="standard GNU commands"
VERSION_="1.3"
DATE_="1999-10-19; last update: 2010-01-02"
AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
URL_="www.comp.eonworks.com"
CATEGORY_="admin"
PLATFORM_="Linux"
SHELL_="bash"
DISTRIBUTE_="yes"

# #############################################################################
# This program is distributed under the terms of the GNU General Public License

# Everybody has a different way of showing their program number version... Thus
# the most reliable way of getting the version number ended up being quite
# inefficient due to frequent tmp file use.
# 2do: sendmail -bt -d0

# HISTORY:
# 2010-01-02 v1.3 - minor bug fix with the use of the tr command

usage () {

    echo >&2 "$NAME_ $VERSION_ - $PURPOSE_
    Usage: $SYNOPSIS_
    Requires: $REQUIRES_
    Options:
    -h, usage and options (this help)
    -l, see this script"
    exit 1
}

case $1 in
    -h) usage ;;
    -l) more $0; exit 1 ;;
esac

# tmp file set up
tmp_1=/tmp/tmp.${RANDOM}$$
tmp_2=/tmp/tmp.${RANDOM}$$

# signal trapping and tmp file removal
trap 'rm -f $tmp_1 $tmp_2 >/dev/null 2>&1' 0
trap "exit 1" 1 2 3 15


[[ $UID != 0 ]] && echo run $NAME_ as root, otherwise some \
installed programs may be listed as not installed

# programs that only accept "--version" option; usually GNU
progs_a[0]=awk
progs_a[1]=bash
progs_a[2]=find
progs_a[3]=tar
progs_a[4]=gcc
progs_a[5]=gpg
progs_a[6]=grep
progs_a[7]=mc
progs_a[8]=mysql
progs_a[9]=php
progs_a[10]=sed
progs_a[11]=exim

# programs that only accept "-V" option
progs_b[0]=ssh
progs_b[1]=httpd
progs_b[2]=python
progs_b[3]=iptables

# ===========================================================================
# LOCAL FUNCTIONS
# ===========================================================================

prog_exist() {
    # purpose: check if a file exist; return status value
    # usage: <program_name>

    which $1 &>/dev/null
    return $?

}

prog_version() {
    # purpose: get the program version string
    # usage: <program_name> <version_notation>

    prog=$1
    version=$2
    name=$(echo $prog | tr '[a-z]' '[A-Z]')
    prog_exist $prog

    if [[ $? != 0 ]];then

        printf "%-10s%-s\n"  "${name}:" "    $prog not installed" >> $tmp_1

    else

        $prog $version &> $tmp_2
        vstring=$(head -n 1 $tmp_2)
        printf "%-10s%-s\n" "${name}: " "$vstring" >> $tmp_1

    fi

}


# ===========================================================================
# MAIN
# ===========================================================================

echo "[ SYSTEM ]" $(uname -a)

# programs that accept "--version"
for a in ${progs_a[@]};do
    prog_version $a --version
done

# programs that accept "-V"
for a in ${progs_b[@]};do
    prog_version $a -V
done

# programs that accept other version notations or the version number is
# not on the first line (perl)

# ------------------------------------------- #
# JAVA
# ------------------------------------------- #

prog=java
version=-version
name=$(echo $prog | tr '[a-z]' '[A-Z]')
prog_exist $prog

if [[ $? != 0 ]];then

    printf "%-10s%-s\n" "${name}:" "    $prog not installed" >> $tmp_1

else

    $prog $version &> $tmp_2
    vstring=$(head -n 1 $tmp_2)
    printf "%-10s%-s\n" "${name}:" "$vstring" >> $tmp_1

fi

# ------------------------------------------- #
# NAMED
# ------------------------------------------- #

prog=named
version=-v
name=$(echo $prog | tr '[a-z]' '[A-Z]')
prog_exist $prog

if [[ $? != 0 ]];then

    printf "%-10s%-s\n" "${name}:" "    $prog not installed" >> $tmp_1

else

    $prog $version &> $tmp_2
    vstring=$(head -n 1 $tmp_2)
    printf "%-10s%-s\n" "${name}:" "$vstring" >> $tmp_1

fi

# ------------------------------------------- #
# PERL
# ------------------------------------------- #

prog=perl
version=-version
name=$(echo $prog | tr '[a-z]' '[A-Z]')
prog_exist $prog

if [[ $? != 0 ]];then

    printf "%-10s%-s\n" "${name}:" "    $prog not installed" >> $tmp_1

else

    $prog $version &> $tmp_2
    vstring=$(sed -n '2p' $tmp_2)
    printf "%-10s%-s\n" "${name}:" "$vstring" >> $tmp_1

fi


# ------------------------------------------- #
# XFREE86
# ------------------------------------------- #

prog=XFree86
version=-version
name=$(echo $prog | tr '[a-z]' '[A-Z]')
prog_exist $prog

if [[ $? != 0 ]];then

    printf "%-10s%-s\n" "${name}:" "    $prog not installed" >> $tmp_1

else

    $prog $version &> $tmp_2
    vstring=$(sed -n '2p' $tmp_2)
    printf "%-10s%-s\n" "${name}:" "$vstring" >> $tmp_1

fi

# ------------------------------------------- #
# LIBC
# ------------------------------------------- #

prog=/lib/libc.so.6
name=LIBC
prog_exist $prog

if [[ $? != 0 ]];then

    printf "%-10s%-s\n" "${name}:" "    $prog not installed" >> $tmp_1

else

    $prog &> $tmp_2
    vstring=$(sed -n '1p' $tmp_2)
    printf "%-10s%-s\n" "${name}:" "$vstring" >> $tmp_1

fi

sort $tmp_1
