package CBDB::Publisher;

our $VERSION = '1.0';

use strict;
use warnings;
use DBI qw(:sql_types);
use CBDB::DB;
use CBDB::Cache;

our @ISA = qw( CBDB::DB );

#################################################
# new() - Constructor
# Example: CBDB::Publisher->new();
# Returns: blessed hash
sub new {
    my $proto = shift;

    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);

    return $self;
}

#################################################
#################### METHODS ####################
#################################################

#################################################
# getId() - Return Id for this publisher
# Parameters: None
# Returns: ID
sub getId {
    my $self = shift;
    return $self->{Id};
}

#################################################
# setId() - Set Id for this publisher
# Parameters: An Id number
# Returns: Nothing
sub setId {
    my $self = shift;
    my $pId = shift or die "publisher.setId( Id ) requires a value.";
    $self->{Id} = $pId;
}

#################################################
# getName() - Return Name for this publisher
# Parameters: None
# Returns: Name
sub getName {
    my $self = shift;
    return $self->{Name};
}

#################################################
# setName() - Set Name for this publisher
# Parameters: A name
# Returns: Nothing
sub setName {
    my $self = shift;
    my $pName = shift || undef;
    $self->{Name} = $pName;
}

#################################################
# remove() - Removes an object from the database
# This method can be called on an object to delete
# that object, or statically, with a where clause,
# to delete multiple objects.  
# Parameters: An optional where clause. See the
# WHERE CLAUSE comment before the 'get' method.
# Returns: Nothing
sub remove {
    my $self = undef;
    my $where = undef;
    my $is_static = undef;
    if ( ref($_[0]) and $_[0]->isa("CBDB::Publisher") ) {
	$self = shift;
	$where = "WHERE id = ?";
    } elsif (ref($_[0]) eq 'HASH') {
	$is_static = 1;
	$where = 'WHERE ' . make_where($_[0]);
    } else {
	die "CBDB::Publisher::remove: Unknown parameters: " . join(' ', @_);
    }

    my $dbh = CBDB::DB::getDB();
    my $query = "DELETE FROM publisher $where";

    my $sth = $dbh->prepare($query);

    if ($is_static) {
	bind_where($sth, $_[0]);
    } else {
	$sth->bind_param(1, $self->getId(), {TYPE=>4});
    }	
    $sth->execute;
    $sth->finish;
    $dbh->disconnect;
}

#################################################
# update() - Updates this object in the database
# Parameters: None
# Returns: Nothing
sub update {
    my $self = shift;
    my $dbh = CBDB::DB::getDB();
    my $query = "UPDATE publisher SET name = ?, id = ? WHERE id = ?";
    my $sth = $dbh->prepare($query);

    $sth->bind_param(1, $self->getName(), {TYPE=>1});
    $sth->bind_param(2, $self->getId(), {TYPE=>4});
    $sth->bind_param(3, $self->getId(), {TYPE=>4});
    $sth->execute;
    $sth->finish;
    $dbh->disconnect;
    CBDB::Cache::set('publisher', $self->getId(), $self);

}

#################################################
# getByPrimaryKey - Retrieves a single object from
# the database based on a primary key
# Parameters: An Id
# Returns: A Publisher object
sub getByPrimaryKey {
    my $pId = shift or die "publisher.get()";
    my $where = [ {'id' => $pId } ];
    return ( get( $where, 1 ) )[0];
}

########################################################################
#                            WHERE  CLAUSE  FORMAT                     #
########################################################################
# The where clause used with the 'get' and 'remove' methods            #
# is in the form of a array reference. Each element of the array       #
# is either a single 'where element' or a reference to another         #
# array. If a reference to another array, that elements in that        #
# array are recursively embedded into the where clause to              #
# allow clauses like " element AND (element OR (element AND element))" #
# A single 'where element' is a hash reference that has at least the   #
# keys 'column' and 'value' which contain the column name and value    #
# of the where element. Other optional keys are 'type' which is the    #
# SQL operator used to join this element with the next (default 'AND') #
# and 'operator' which is the SQL operator used between the column     #
# name and the value (default '=').                                    #
########################################################################


#################################################
# get - Retrieves objects from the database
# Parameters: Optional where clause
# Returns: Array of Publisher objects
sub get {
    my $wheres = undef;
    my $do_all = 1;
    if (ref($_[0]) eq 'ARRAY') { $wheres = shift; $do_all = shift if @_; }
    else { $do_all = shift; }

    my $dbh = CBDB::DB::getDB();
    my $where .= ' WHERE  ' . make_where( $wheres );
    my $query = qq{
	SELECT publisher.name as publisher_name, 
	publisher.id as publisher_id 
	    FROM publisher 
	$where
    };
    my $sth = $dbh->prepare($query);
    bind_where( $sth, $wheres );
    $sth->execute;
    my @publishers;
    while (my $Ref = $sth->fetchrow_hashref) {
	my $publisher = undef;
	if (CBDB::Cache::has('publisher', $Ref->{publisher_id})) {
	    $publisher = CBDB::Cache::get('publisher', $Ref->{publisher_id});
	} else { 
	    $publisher = CBDB::Publisher::populate_publisher( $Ref );

	    CBDB::Cache::set('publisher', 
		$Ref->{publisher_id}, $publisher);
	}
	push(@publishers, $publisher);
    }
    $sth->finish;
    $dbh->disconnect;
    return @publishers;
}

#################################################
# populate_publisher - Return a publisher object
# populated from a result set
# Parameters: Data from a DBI::fetchrow_hashref
# method call
# Returns: A Publisher object
sub populate_publisher {
    my $Ref = shift;
    my $publisher = CBDB::Publisher->new();
    $publisher->setName($Ref->{publisher_name});
    $publisher->setId($Ref->{publisher_id});

    return $publisher;
}

#################################################
# create - Inserts the object into the database
# Parameters: None
# Returns: A Publisher object (redundantly, since
# this method is called on that same object)
sub create {
    my $self = shift;
    my $dbh = CBDB::DB::getDB();
    my $query = "INSERT INTO publisher ( name, id ) VALUES ( ?, ? )";
    my $sth = $dbh->prepare($query);
    my $pk_id = undef;

    $sth->bind_param(1, $self->getName(), {TYPE=>1});
    $sth->bind_param(2, undef, {TYPE=>4});
    $sth->execute;
    $sth->finish;

    $pk_id = CBDB::DB::get_pk_value($dbh, 'publisher_id');
    $self->setId( $pk_id);

    $dbh->disconnect;
    CBDB::Cache::set('publisher', $self->getId(), $self);
    return $self;
}

#################################################
# make_where() - Construct a WHERE clause from a
# well-defined hash ref
# Parameters: Where clause reference
# Returns: Where clause string
sub make_where {
    my $where_ref = shift;
    if ( ref($where_ref) ne 'ARRAY' ) { 
	die "CBDB::Publisher::make_where: Unknown parameters: " . 
	    join(' ', @_);
    }
    my @wheres = @$where_ref;
    my $element_counter = 0;
    my $where = "";
    for my $element_ref (@wheres) {
	if (ref($element_ref) eq 'ARRAY') { 
	    $where .= make_where($element_ref);
	} elsif (ref($element_ref) ne 'HASH') { 
	    die "CBDB::Publisher::make_where: malformed WHERE parameter: " 
	    . $element_ref; 
	}
	my %element = %$element_ref;
	my $type = 'AND';
	if (not $element_counter and scalar keys %element == 1 and 
	    exists($element{'TYPE'})) {
	    $type = $element{'TYPE'};
	} else {
	    my $table = "publisher";
	    my $operator = "=";
	    if (exists($element{'table'})) { $table = $element{'table'}; }
	    if (exists($element{'operator'})) 
	    { $operator = $element{'operator'}; }
	    if ($element_counter) { $where .= " $type "; } else 
	    { $element_counter = 1; }
	    for my $term ( grep !/^(table|operator)$/, keys %element ) {
		$where .= "$table.$term $operator ?";
	    }
	}
    }
    return $where;
}

#################################################
# bind_where() - Executes the statement
# handle->bind method calls that bind where
# element
# Parameters: Where clause array ref and a scalar
# ref to a counter number That tells the method
# which parameter to bind to.
# Returns: Nothing
sub bind_where {
    my $sth = shift;
    my $where_ref = shift;
    my $counter_ref = shift || undef;
    my $counter = (ref($counter_ref) eq 'Scalar')?  $$counter_ref : 1;
    if ( not $sth->isa('DBI::st') or ref($where_ref) ne 'ARRAY' ) { 
	die "CBDB::Publisher::make_where: Unknown parameters: " 
	    . join(' ', @_);
    }
    my @wheres = @$where_ref;
    for my $element_ref (@wheres) {
	if (ref($element_ref) eq 'ARRAY') { 
	    bind_where($sth, $element_ref, \$counter);
	} elsif (ref($element_ref) ne 'HASH') {
	    die "CBDB::Publisher::make_where: malformed WHERE parameter: " 
		. $_;
	}
	my %element = %$element_ref;
	unless (not $counter and scalar keys %element == 1 and exists($element{'TYPE'})) {
	    my $table = "publisher";
	    if (exists($element{'table'})) {
		$table = $element{'table'};
	    }
	    for my $term ( grep !/^(table|operator)$/, keys %element ) {
		$sth->bind_param($counter, $element{$term}, 
		    {TYPE=>CBDB::DB::getType($table,$term)});
		$counter++;
	    }
	}
    }
}

1;
