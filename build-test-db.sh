#!/bin/bash

#EXECUTABLE="/usr/local/mysql-standard-5.0.27-osx10.4-i686/bin/mysql"
#EXECUTABLE="/usr/local/mysql-5.0.45-osx10.4-i686/bin/mysql"
EXECUTABLE="/usr/local/mysql/bin/mysql"

cat birdwalker_dump.sql | $EXECUTABLE -u root -D HelloWorld_test




