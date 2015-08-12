#!/usr/bin/perl -w
use strict;
use DBI;
use CGI;
use Template;
use URI::Escape;

# This code prints a small amount of HTML.
# Mostly, it creates data structures to plug into the template file,
# book_view.tt.

my $cgi = CGI->new();
my $tt = Template->new();

# The HTPP header must always be printed.
print 'Content-Type: text/html', "\n\n";

my $Records; # a container for our data
$Records->{title} = 'MySQL CGI Example with The Template Took Kit';
$Records->{vlink} = '#0000ff';
$Records->{bgcolor} = '#ffffff';

# If we have parameters, the user clicked on something.
# Otherwise, we just exit.

if($cgi->param) {
# Remove spaces from around the parameter that was passed in.
    my $titleword = $cgi->param('titleword');
    $titleword =~ s/^\s+//;
    $titleword =~ s/\s+$//;
# If the user typed in more the one word, use just the first.
    $titleword =~ s/\s+.*//;
    $Records->{esc_titleword} = uri_escape($titleword);
    $Records->{titleword} = $titleword;

# The following block of code runs when the program is first
# invoked or when the user has not typed in a word for the
# title search.

    unless ($titleword) {
	$Records->{no_word} = 1;
	$tt->process('book_view.tt',$Records) 
	    or print $tt->error();
	exit;
    }

    my @rows;
    my $url = $cgi->url ;

    # Find out which column, if any, the user clicked on.
    # The form passes that information in the 'col' parameter.
    my $order = $cgi->param('col');

    my $t = $cgi->param('t');

    # Fill in the headers. The information for each header
    # is an element of an array.
    # The array is stored in a hash element with the key $headers.
    # The $Records variable points to the whole hash.

    push(@{$Records->{headers}} , { col => 1,name => 'ISBN',toggle => 1});
    push(@{$Records->{headers}} , { col => 2,name => 'Title',toggle => 1});
    push(@{$Records->{headers}} , { col => 3,name => 'PubDate',toggle => 0});
    push(@{$Records->{headers}} , { col => 4,name => 'Author',toggle => 1});

# Check each column to see whether the user clicked on it.
# If so, we toggle the sorting order for that column.
# If the toggle was 1, we change it to 0 (that is, 1 - 1).
# If the toggle was 0, we change it to 1 (that is, 1 - 0).

    for my $hash ( @{$Records->{headers}}) {
	if($hash->{col} == $order) {
		$hash->{toggle} = 1 - $t;
	}
    }
	
    my $attr = ($t == 1)? 'asc':'desc';

    # Call getPat function, shown later, to transform the user's
    # word into a regular expression for searching.
    my $pat = getPat($titleword);

######### Start of interaction with the database #########

    # First invocation of a DBI method.
    # Connect to the database.
    # Set the RaiseError flag to catch all DBI errors in $@.

    # A row counter, used to mark alternating rows with different colors.
    my $c = 0;

    my $dbh;

    eval {
	$dbh = DBI->connect('dbi:mysql:Books:localhost','andy','ALpswd',
		{PrintError => 0 ,RaiseError => 1});

    # Create the query. Get the four fields for which we set up
    # headers in the $Records array earlier.
    # The 'rlike' clause requests a regular expression search,
    # a bit of nonstandard SQL supported by MySQL.
    # $attr is either undefined or 'desc' for a descending sort.

	my $sql = qq{
	    select isbn,title,pubdate,author
		from Titles where title rlike ? 
		and pubdate is not null
		order by $order $attr
	};

	my $sth = $dbh->prepare($sql);
	$sth->execute($pat);

######### End of interaction with the database #########

    # Fetch the data and add it to $Records as part of its
    # 'records' hash element.
	while (my $row = $sth->fetchrow_arrayref) {
	    ++$c;
	    my $hash = {
		isbn => {
		    value => $row->[0],
		},
		title => { 
		    value => $row->[1],
		},
		pubdate => {
		    value => $row->[2],
		},
		author => {
		    value => $row->[3],
		}
	    };
	    push(@{$Records->{records}},$hash);
	}
	$dbh->disconnect;
    };
    if($@) {
	$Records->{error} = $@;
	$tt->process('book_view.tt',$Records) 
	    or print $tt->error();
	exit;
    }

    unless ($c) {
	$Records->{no_rows} = 1;
	$tt->process('book_view.tt',$Records) 
	    or print $tt->error();
	exit;
    }
}

# Now run $Records through the template processor

$tt->process('book_view.tt',$Records) 
    or print $tt->error();

exit(0);

######### getPat Function #############################

# getPat accepts a word and returns a regular expression that
# MySQL will use to find titles. Knowing our data, we perform
# some sneaky tricks on certain input so that a search for 'Java'
# finds JavaBeans and words beginning with J2, while a search for
# .NET finds C and C# titles.

sub getPat {
    my $titleword = shift;
    my $_what = quotemeta $titleword;
    my $pat;
    if($titleword =~ /^[Jj][Aa][Vv][Aa]$/) {
	$_what .= '|j2[a-z][a-z]|javabean(s)?';
	$pat = "(^|[^a-zA-Z])($_what)([^a-zA-Z]|\$)";
    } elsif($titleword =~ /\.[nN][eE][tT]/) {
	$_what .= '|[cC]\#';
	$pat = "(^|[a-zA-Z]+)?($_what)([^a-zA-Z]|\$)";
    } elsif($titleword =~ /\.\*/) {
	$pat = ".*";
    } else {
	$pat = "(^|[^a-zA-Z])($_what)([^a-zA-Z]|\$)";
    }
    return $pat;
}
