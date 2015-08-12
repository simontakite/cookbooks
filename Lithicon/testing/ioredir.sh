#!/bin/bash

case $1 in
   pre)
      exec 2>&1			# From here on, redirects stderr to stdout
      echo "$0: Running $1"
      echo "Skriver error" >&2	# Should be displayed in stdout
      ;;
   post)
      echo "$0: Running $1"
      echo "Skriver error" >&2	# Should be displayed in stderr
      ;;
esac

