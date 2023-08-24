#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

DB_USER="username"
DB_PASS="password"
DB_NAME="database-name"
BACKUP_DIR="/home/ubuntu/backup"

# Create a timestamp for the backup file
TIMESTAMP=$(date +"%Y%m%d%H%M%S")

# Create a directory for the backup
mkdir -p "$BACKUP_DIR"

# Create a database dump and compress it
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_DIR/$DB_NAME-$TIMESTAMP.sql"
gzip "$BACKUP_DIR/$DB_NAME-$TIMESTAMP.sql"

# remove old backups that are 7days old and above
find $BACKUP_DIR -type f -name "*.gz" -mtime +7 -delete

# add the script to cron jobs on the linux server and set it to run at a certain intervals
# add the execute bit to the file chmod +x backup.sh