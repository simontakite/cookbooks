#!/usr/bin/env bash
# cookbook filename: dbiniter
#
# initialize databases from a standard file
# creating databases as needed.

DBLIST=$(mysql -e "SHOW DATABASES;" | tail -n +2)
select DB in $DBLIST "new..."
do
    if [[ $DB == "new..." ]]
    then
        printf "%b" "name for new db: "
        read DB rest
        echo creating new database $DB
        mysql -e "CREATE DATABASE IF NOT EXISTS $DB;"
    fi

    if [ "$DB" ]
    then
        echo Initializing database: $DB
        mysql $DB < ourInit.sql
    fi
done
