#!/usr/bin/perl -w

use strict;
use DBI;
my $server = 'localhost';
my $db = 'Books'; # The name of our database.
my $username = 'andy' ;# the username 
my $password = 'ALpswd' ;# the password

my $dbh = DBI->connect("dbi:mysql:$db:$server", $username, $password,  { RaiseError => 1 });

my $query = "SELECT * FROM Titles"; 

my $sth = $dbh->prepare($query);

query:$sth->execute();

while (my $row = $sth->fetchrow_arrayref) {
    print join("\t",@$row),"\n";
}
$dbh->disconnect;
