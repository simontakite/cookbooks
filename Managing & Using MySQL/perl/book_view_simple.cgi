#!/usr/bin/perl -w
use strict;
use DBI;
use CGI;
use URI::Escape;

# Hash ref that maps a column type to its two display attributes.
# Used in TD element.
my $Types = {
    1 => ['left',''],
    4 => ['right','nowrap'],
};

# Hash ref of various attributes for each column.
my $ColDef = {
    isbn => {
	col => 1,
	display => 'ISBN',
	header => '2',
	sort => 1
    },
    title => {
	col => 2,
	display => 'Title',
	header => '1',
	sort => 1
    },
    pubdate => {
	col => 3,
	display => 'PubDate',
	header => '1',
	sort => 0 # Defaults to descending, so new books show first.
    },
    author => {
	col => 4,
	display => 'Author',
	header => '1',
	sort => 1
    }
};

my $cgi = CGI->new();

# The header (with HTTP commands) must always be printed.
print $cgi->header(), "\n",
    $cgi->start_html(
	    -bgcolor => '#ffffff',
	    -title => 'Sample CGI for MySQL Book'), "\n";

# Print the search form.
printForm();

# If we have parameters, the user clicked on something.
# Otherwise, we just exit.
#
if($cgi->param) {
# Remove spaces from around the parameter that was passed in.
    my $titleword = $cgi->param('titleword');
    $titleword =~ s/^\s+//;
    $titleword =~ s/\s+$//;
# If the user typed in more the one word, use just the first.
    $titleword =~ s/\s+.*//;

# Stick the cleaned-up word back into the cgi object.
    $cgi->param(-name => 'titleword', -value => $titleword);

    unless ($titleword) {
	print $cgi->h2("I need a title word");
	print $cgi->end_html;
	exit;
    }

    my @rows;
    my $url = $cgi->url ;

    # Find out which column, if any, the user clicked on.
    # The form passes that information in the 'order' parameter.
    my $order = $cgi->param('order');
    my $t = $cgi->param('t');
    my $attr = ($t == 1)? '':'desc';

######### Start of interaction with the database #########

    # First invocation of a DBI method.
    # Connect to the database.
    my $dbh = DBI->connect('DBI:mysql:Books:localhost','andy','ALpswd',
	    {PrintError => 0 ,RaiseError => 0});
    unless($dbh) {
	printErrorPage();
    }

    # Call getPat function, shown later, to transform the user's
    # word into a regular expression for searching.

    my $pat = getPat($titleword);

    # Create the query. Get the four fields for which we set up
    # headers in the $Records array earlier.
    # The 'rlike' clause requests a regular expression search,
    # a bit of nonstandard SQL supported by MySQL.
    # $attr is either undefined or 'desc' for a descending sort.

    my $sql = qq{
	select isbn, title, pubdate, author
	    from Titles where title rlike ?
	    and pubdate is not null
	    order by $order $attr
    };

    my $sth = $dbh->prepare($sql);
    unless($sth) {
	printErrorPage();
    }
    $sth->execute($pat);

######### End of interaction with the database #########

   my $typeNums = $sth->{TYPE};

    # A row counter, used to mark alternating rows with different colors.
    my $c;

    # In the following loop, we prepare HTML within a table,
    # one row of HTML for each row of database results.
    # This HTML will be printed later.
    my @Rows;
    while(my $row = $sth->fetchrow_arrayref) {

        # Show date in attractive "Mon year" format.
	$row->[2] = strftime("%b %Y",localtime($row->[2]));
	++$c; # Increment row counter.

	($c % 2)?push(@Rows, '<tr bgcolor="#cccccc">'):
		    push(@Rows,'<tr bgcolor="#ffffff">');
	push(@Rows, $cgi->td({align => 'right'}, $c));

	for my $n (0..$sth->{NUM_OF_FIELDS} - 1) {
	   push(@Rows, $cgi->td({ align => $Types->{$typeNums->[$n]}[0] ,
		    $Types->{$typeNums->[$n]}[1]} ,$row->[$n]));
	}

	push(@Rows, '</tr>', "\n");

    }

    # The query found no matching titles.
    unless ($c) {
	printNoRows();
	print $cgi->end_html;
	exit;
    }

    print '<table border=1>', "\n",
	"<tr bgcolor=\"#66cc66\">";

# The following loops through the columns and prints
# the headers of the table.
    for my $u ('isbn','title','pubdate','author') {
	my $col_url = $url;

# If the user clicked on a column, we toggle the
# sorting order for that column.
# If the toggle was 1, we change it to 0 (that is, 1 - 1).
# If the toggle was 0, we change it to 1 (that is, 1 - 0).
# All other columns use the default sort order listed in
# $ColDef->{sort}.

	if($ColDef->{$u}{col} == $order) {
	    $ColDef->{$u}{sort} = 1 - $t;
	}

# We use the . operator here just to wrap the code so
# it fits on the page.
# Special characters must be escaped.
	$col_url .=
	    "?titleword=".uri_escape($titleword).
	    "&order=$ColDef->{$u}{col}".
	    "&t=$ColDef->{$u}{sort}";
	print $cgi->th({ colspan => $ColDef->{$u}{header} },
		$cgi->a({href => $col_url},
		    $ColDef->{$u}{display})), "\n";

    } # end of for loop

    print '</tr>', "\n";
    print "@Rows\n";
    print '</table>', "\n";

    $dbh->disconnect;
}

print $cgi->end_html;

######### Functions #############################

sub printNoRows {
    print $cgi->h2('No titles contain the word ' .
		   $cgi->param('titleword') );
}

# getPat accepts a word and returns a regular expression that
# MySQL will use to find titles. Knowing our data, we perform
# some sneaky tricks on certain input so that a search for 'Java'
# finds JavaBeans and words beginning with J2, while a search for
# .NET finds C and C# titles.
# We wrap the word in regular expression verbiage to search for the
# string as a complete word; thus, a search for Java will not turn up
# JavaScript titles.
# MySQL does not support the \b or \w metacharacters known to
# Perl programmers, so we have to use ungainly constructs like
# (^|[^a-zA-Z]) in our regular expression.

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

# printForm creates our search form.
sub printForm {
    # If we are displaying the results from a word submitted by the user,
    # we extract that word using the param() call and insert it back into
    # the form. This is a minor convenience to offer the user, but it
    # illustrates an important principle: how to maintain state between
    # CGI calls so you can present a succession of forms to the user
    # and remember what the user submitted in previous forms.
    my $titleword = $cgi->param('titleword');
    $titleword =~ s/^\s+//;
    $titleword =~ s/\s+$//;
    $titleword =~ s/\s+.*//;
    $cgi->param(-name => 'titleword', -value => $titleword);
    print $cgi->h2('Enter a <i>single</i> title word.'), "\n",
    $cgi->start_form(
	    -method => 'post',
	    -action => '/cgi-bin/book_view_simple.cgi'), "\n",
    $cgi->textfield(-name => 'titleword'), "\n",

    # We use the -override attribute here because we always want these
    # values when the form is submitted.
    # Searches from the form are always returned in descending order
    # by pubdate (column 3).
    $cgi->hidden(-name => 'order', -value => 3, -override => 1),
    $cgi->hidden(-name => 't', -value => 0, -override => 1),
    $cgi->submit(-value => 'Search titles');

    print $cgi->end_form, "\n";
}

# printErrorPage notifies the user of an error in trying
# to access the database.

sub printErrorPage {
    print $cgi->h1('An error has occurred'),
    $cgi->p($cgi->a({href => $cgi->self_url},'Try again'),' or wait
    till later in case there was a temporary database problem.');}
