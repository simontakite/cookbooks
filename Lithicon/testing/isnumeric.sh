#!/bin/bash

function isnumeric {
case $1 in
    ''|*[!0-9]*) return 1;;
    *) return 0 ;;
esac
}

$(isnumeric $1) && echo "JAAAA" || echo "FAIL"
