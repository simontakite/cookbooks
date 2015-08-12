#!/bin/bash
# restore all users' known hosts file from previous snapshot.
for f in $(ls /net/users/); do
  if [ -f "/net/users/$f/.ssh/known_hosts" ]; then
    cp /net/users/$f/.ssh/.snapshot/nightly.0/known_hosts /net/users/$f/.ssh/known_hosts;
    chown $f /net/users/$f/.ssh/known_hosts
  fi
done

