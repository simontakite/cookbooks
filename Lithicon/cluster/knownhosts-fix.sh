#!/bin/bash
# remove lima / compute nodes from known_hosts files to avoid warning.
MATCH="^c[0-2]-"
for f in $(ls /net/users/); do
  if [ -f "/net/users/$f/.ssh/known_hosts" ]; then
    before=$(cat /net/users/$f/.ssh/known_hosts|wc -l)
    grep -v $MATCH /net/users/$f/.ssh/known_hosts > /tmp/$f-knownhosts;
    after=$(cat /tmp/$f-knownhosts|wc -l)
    mv /tmp/$f-knownhosts /net/users/$f/.ssh/known_hosts;
    chown $f /net/users/$f/.ssh/known_hosts
    echo "$f: Before=$before After=$after"
  fi
done
