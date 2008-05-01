#!/bin/bash

#EXECUTABLE="/usr/local/mysql-standard-5.0.27-osx10.4-i686/bin/mysqldump"
#EXECUTABLE="/usr/local/mysql-5.0.45-osx10.4-i686/bin/mysqldump"
EXECUTABLE=/usr/local/mysql/bin/mysqldump

AUTHFLAGS="-u root HelloWorld_development"
OTHERFLAGS="--extended-insert=FALSE --quote-names=TRUE --complete-insert=TRUE --comments=FALSE --add-locks=FALSE"

$EXECUTABLE $OTHERFLAGS $AUTHFLAGS > birdwalker_dump.sql