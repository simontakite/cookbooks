#!/usr/bin/env bash
# cookbook filename: finding_tools

# export may or may not also be needed, depending on what you are doing

# These are fairly safe bets
_cp='/bin/cp'
_mv='/bin/mv'
_rm='/bin/rm'

# These are a little trickier
case $(/bin/uname) in
    'Linux')
        _cut='/bin/cut'
        _nice='/bin/nice'
        # [...]
    ;;
    'SunOS')
        _cut='/usr/bin/cut'
        _nice='/usr/bin/nice'
        # [...]
    ;;
    # [...]
esac
