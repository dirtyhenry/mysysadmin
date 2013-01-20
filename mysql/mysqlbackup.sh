#!/bin/sh

# Usage: mysqlbackup database/username 
# 

# ERROR CODES
SUCCESS=0
ILLEGAL_ARGUMENTS=1
MISSING_OPTIONS_FILE=2
MYSQLDUMP_FAILED=3

BACKUP_HOME=$HOME/work/backup

if [ $# -ne 1 ]; then
    echo "Usage: $0 database_and_username"
    exit $ILLEGAL_ARGUMENTS
fi

DATABASE=$1

if [ ! -f $BACKUP_HOME/$DATABASE-mysql-opts ]; then
    echo "Error: options file $BACKUP_HOME/$DATABASE-mysql-opts can't be found."
    exit $MISSING_OPTIONS_FILE
else
    chmod 400 $BACKUP_HOME/$DATABASE-mysql-opts
fi
    
echo "Dumping database $DATABASE"
mysqldump --defaults-file=$BACKUP_HOME/$DATABASE-mysql-opts -h localhost -u $DATABASE $DATABASE > $BACKUP_HOME/$DATABASE.sql

if [ -f $BACKUP_HOME/$DATABASE.sql ]; then
    gzip $BACKUP_HOME/$DATABASE.sql
    mv $BACKUP_HOME/$DATABASE.sql.gz $BACKUP_HOME/$DATABASE-`date +%y%m%d`.sql.gz
    exit $SUCCESS
else
    echo "Error: backup could not be completed."
    exit $MYSQLDUMP_FAILED
fi
