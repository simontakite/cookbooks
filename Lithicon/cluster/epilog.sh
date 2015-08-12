#!/bin/sh

binc="grid.binc"
dat="grid.dat"

echo "--- epilog start ---"

if [ -f $dat ]; then
    if [ -f $binc ]; then
        echo "Removing $dat..."
        rm $dat
        echo "Done."
    else
        echo "$binc not found, keeping $dat."
    fi
else
    echo "No grid present. Nothing to be done."
fi

echo "--- epilog end ---"
