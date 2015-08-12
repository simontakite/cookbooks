#!/usr/bin/perl
use strict;
use warnings;

use lib '/home/tallwine/mysql_examples/lib';
use CBDB::Publisher;
my $VERSION = 1.0;

# First let's create a new publisher object
my $pub = CBDB::Publisher->new();

# Now let's set some data... We're in a hurry, so
# we can't be bothered with good spelling...
$pub->setName("Joe's Boks");

# Note that we don't set the 'id'. This is an
# auto-increment field that is taken care of
# automatically by the database. A more abstract
# way of thinking about it is that the 'id' is not
# a real-world property of this object, it only
# exists because of the necessities of
# object-relational design. Therefore, at the
# controller level, we shouldn't have to worry
# about it.

print 'Our new publisher is ' . $pub->getName(),"\n";

#
# If the program were to terminate at this point,
# this object's data would be lost. We need to
# save it to that database for it to be persistent.
#

$pub->create();

# Now the object has been created in the database
# and is persistent?

my $new_id = $pub->getId();

# Now that the object has been persisted, it has
# been assigned a primary key We can store that
# primary key in a variable for later reference.

# ... (some time later)

# Let's retrieve the object we created earlier...
# We use the getByPrimaryKey value with the PK we
# stored earlier.  Notice that this is a static
# method; called on the class itself.

my $pub2 = CBDB::Publisher::getByPrimaryKey($new_id);

# Because of the caching mechanism, $pub2 is
# literally the same object as $pub.

if ($pub2 != $pub) { 
    print "Whoops! Something isn't working right!\n" 
}

# Let's change some data and fix that typo from earlier.

$pub2->setName("Joe's Books");

# At this point, the data has been changed in the
# object only, not in the underlying data store.
# However, since all active instances of this
# object are references to the same object, this
# change takes place everywhere in the application
# immediately.

print "The publisher's name is now " . $pub->getName(),"\n";

# This will print Joe's Books, not Joe's Boks,
# even though we didn't explicitly touch $pub.

# Now let's save these changes to the database...

$pub2->update(); # <-- This could just as well have been $pub

# The data has been changed now...

# ... (even later)

# Okay we're done with this data now, time to delete the row...

$pub->remove();

# The underlying data row in the database has now
# been removed. However, this object (as well as
# $pub2) still contains the data until the program
# is terminated or the objects are destroyed.

print "The publisher " . $pub->getName() . " was just erased...\n";
