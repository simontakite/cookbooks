package CBDB::DB;

use strict;
use warnings;
use BM::mysql;

my $VERSION = '0.1';
use constant DSN => "DBI:mysql:database=Books;host=localhost";
use constant USER => "tallwine";
use constant PASSWORD => "bob";


my $types = {
    'creator' => { 'name' => 1, 'id' => 4 },
    'book' => { 'title' => 1, 'publisher_id' => 4, 'date' => 11, 'id' => 4 },
    'book_creator' => { 'book_id' => 4, 'creator_id' => 4, 'role_id' => 4 },
    'publisher' => { 'name' => 1, 'id' => 4 },
    'role' => { 'name' => 1, 'id' => 4 },
};

#####################################################################
# getDB - Returns a database handle connection for the database.
# Parameters: None.
# Returns: DBH Connection Handle.
sub getDB {
    my $dbh = DBI->connect(DSN,USER,PASSWORD,{PrintError => 1,RaiseError => 1});
    return $dbh;
}

#####################################################################
# get_pk_value - Returns the most recent auto_increment value for a PK.
# Parameters: Database Handle.
# Returns: Primary key value.
sub get_pk_value {
    my $dbh = shift or die "DB::get_pk_value needs a Database Handle...";

    my $dbd = BM::mysql->new();
    return $dbd->get_pk_value( $dbh );
}

#####################################################################
# getType: Returns the type of a column within a table.
# Parameters: Table name and column name.
# Returns: DBI Type code.
sub getType {
    my $table = shift;
    my $col = shift;
    return $types->{$table}{$col};
}

1;
