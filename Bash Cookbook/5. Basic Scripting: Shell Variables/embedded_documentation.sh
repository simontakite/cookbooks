#!/usr/bin/env bash
# cookbook filename: embedded_documentation

echo 'Shell script code goes here'

# Use a : NOOP and here document to embed documentation,
: <<'END_OF_DOCS'

Embedded documentation such as Perl's Plain Old Documentation (POD),
or even plain text here.

Any accurate documentation is better than none at all.

Sample documentation in Perl's Plain Old Documentation (POD) format adapted from
CODE/ch07/Ch07.001_Best_Ex7.1 and 7.2 in the Perl Best Practices example tarball
"PBP_code.tar.gz".

=head1 NAME

MY~PROGRAM--One line description here

=head1 SYNOPSIS

  MY~PROGRAM [OPTIONS] <file>

=head1 OPTIONS

  -h = This usage.
  -v = Be verbose.
  -V = Show version, copyright and license information.


=head1 DESCRIPTION

A full description of the application and its features.
May include numerous subsections (i.e. =head2, =head3, etc.)


[...]


=head1 LICENSE AND COPYRIGHT

=cut

END_OF_DOCS
