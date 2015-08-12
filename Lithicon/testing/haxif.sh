#!/bin/bash
mount=$1
! grep -q $mount /proc/mounts && echo $mount is not mounted || echo "OK"
