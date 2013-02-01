#!/bin/sh

# Usage: svnbackup homedir 
# 

# ERROR CODES
SUCCESS=0
INVALID_DIRECTORY=1
SVNADMIN_DUMP_FAILED=2

BACKUP_HOME=$HOME/work/backup

if [ $# -ne 1 ]; then
    echo "Usage: $0 directory"
    exit $ILLEGAL_ARGUMENTS
fi

SVN_PATH=$1
SVN_NAME=`basename $SVN_PATH`

if [ ! -d $SVN_PATH ]; then
    echo "Error: directory $SVN_PATH can't be found."
    exit $INVALID_DIRECTORY
fi
    
echo "Dumping SVN $SVN_NAME at $SVN_PATH"
svnadmin dump $SVN_PATH > $BACKUP_HOME/$SVN_NAME.svn

if [ -f $BACKUP_HOME/$SVN_NAME.svn ]; then
    gzip $BACKUP_HOME/$SVN_NAME.svn
    mv $BACKUP_HOME/$SVN_NAME.svn.gz $BACKUP_HOME/$SVN_NAME-`date +%y%m%d`.svn.gz
    echo "Backup available at $BACKUP_HOME/$SVN_NAME-`date +%y%m%d`.svn.gz"
    exit $SUCCESS
else
    echo "Error: backup could not be completed."
    exit $SVNADMIN_DUMP_FAILED
fi
