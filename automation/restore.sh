#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Database credentials
DB_USER="your_db_user"
DB_PASS="your_db_password"
DB_NAME="your_db_name"

# Backup directory
BACKUP_DIR="/path/to/backup"

# Specify the backup file to restore (change this)
BACKUP_FILE="your_backup_file.sql.gz"

# Decompress the backup file
gzip -d "$BACKUP_DIR/$BACKUP_FILE"

# Restore the database from the backup
mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$BACKUP_DIR/${BACKUP_FILE%.gz}"

echo "Database backup restored: $BACKUP_FILE"

# add the script to cron jobs on the linux server and set it to run at a certain intervals
# add the execute bit to the file chmod +x restore.sh
