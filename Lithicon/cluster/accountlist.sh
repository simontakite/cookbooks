#!/bin/bash
echo
echo \***** Registered projects \*****
qacct -j | grep account | sort | uniq
echo
