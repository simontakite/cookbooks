# cookbook filename: finding_ipas

# IPv4 Using awk, cut and head
$ /sbin/ifconfig -a | awk '/(cast)/ { print $2 }' | cut -d':' -f2 | head -1

# IPv4 Using Perl, just for fun
$ /sbin/ifconfig -a | perl -ne 'if ( m/^\s*inet (?:addr:)?([\d.]+).*?cast/ ) { print qq($1\n); exit 0; }'


# IPv6 Using awk, cut and head
$ /sbin/ifconfig -a | egrep 'inet6 addr: |address: ' | cut -d':' -f2- \
    | cut -d'/' -f1 | head -1 | tr -d ' '

# IPv6 Using Perl, just for fun
$ /sbin/ifconfig -a | perl -ne 'if ( m/^\s*(?:inet6)? \s*addr(?:ess)?: ([0-9A-Fa-f:]+)/ ) { print qq($1\n); exit 0; }'
