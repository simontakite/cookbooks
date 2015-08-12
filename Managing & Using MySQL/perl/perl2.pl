#!/usr/bin/perl -w

use strict;
use DBI;

my $server = 'localhost';
my $db = 'Books';
my $username = 'andy' ;
my $password = 'ALpswd' ;

my $dbh = DBI->connect("dbi:mysql:$db:$server", $username, $password);

# The SQL contains a question mark to indicate a bind variable.
my $query = q{
    SELECT isbn,title FROM Titles 
	where author like ?
}; 

my $sth = $dbh->prepare($query);

# We pass an argument to bind the value
# '%Tim Bunce%' to our bind variable.
$sth->execute('%Tim Bunce%'); #just books published in 2001

while (my $row = $sth->fetchrow_arrayref) {
    print join("\t",@$row),"\n";
}

$dbh->disconnect;
