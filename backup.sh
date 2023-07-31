#!/bin/bash

# Javier Ferrándiz Fernández - 28/07/2023 - https://github.com/javisys

# If we want to make it more complete we can use the tools rsync, borgbackup, rsnapshot, duplicity. 
# They offer options to perform full, differential and incremental backups in a more automated and secure way. 
# These tools will allow you to create a more sophisticated backup system suitable for your specific needs.

# Check if current user is sudo (administrator)
if [ "$(id -u)" -ne 0 ];
then
    echo "This script must be run with superuser privileges."
    exit 1
fi

# Directory where backups will be stored
backup_dir="/var/backups"

# Backup file name
backup_fileN="backup-$(date +%Y%m%d%H%%M%S).tar.gz"

# Create backup directory if it does not exist
mkdir -p "$backup_dir"

# Create a complete backup of the entire system using "tar"
tar czf "$backup_dir/$backup_fileN --exclude="$backup_dir" --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/run --exclude=/mnt --exclude=/media --exclude=/lost+found --exclude=/tmp --exclude=/var/tmp --exclude=/var/run ."

# Verify if the backup was performed correctly
if [ "$?" -eq 0 ];
then
    echo "Full backup successfully completed: $backup_fileN"
else
    echo "Backup failed"
fi
