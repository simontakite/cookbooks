#!/bin/bash

if (( "$1" > 1 )) && (( "$1" < 5  )); then
	echo $1
fi
