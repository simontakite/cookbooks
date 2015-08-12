# cookbook filename: perl_sub_commify

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Add comma thousands separator to numbers
# Returns: input string, with any numbers commified
# From Perl Cookbook2 2.16, pg 84
sub commify {
    @_ == 1 or carp ('Sub usage: $withcomma = commify($somenumber);');

    # From _Perl_Cookbook_1 page 64, 2.17 or _Perl_Cookbook_2 page 84, 2.16
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}
