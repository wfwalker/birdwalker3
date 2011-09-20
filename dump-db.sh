#!/bin/bash

#EXECUTABLE="/usr/local/mysql-standard-5.0.27-osx10.4-i686/bin/mysqldump"
#EXECUTABLE="/usr/local/mysql-5.0.45-osx10.4-i686/bin/mysqldump"
EXECUTABLE=/usr/local/mysql/bin/mysqldump

AUTHFLAGS="-u root"
DATABASENAME="HelloWorld_development"
TABLENAMES="counties countyfrequency families locations photos sightings species states taxonomy trips users posts"
OTHERFLAGS="--extended-insert=FALSE --quote-names=TRUE --complete-insert=TRUE --comments=FALSE --add-locks=FALSE"

echo $EXECUTABLE $OTHERFLAGS $AUTHFLAGS $DATABASENAME $TABLENAMES 

$EXECUTABLE $OTHERFLAGS $AUTHFLAGS $DATABASENAME $TABLENAMES > birdwalker_dump.sql