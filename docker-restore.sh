#!/bin/bash

 # Define backup directory and log file
 BACKUP_DIR="$HOME/docker-backup-restore/backups"
 LOG_FILE="$BACKUP_DIR/restore.log"
 TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# List available backups
echo "Available backups:"
ls -lh "$BACKUP_DIR" | grep ".tar.gz"

# Prompt user for backup file to restore
read -p "Enter the name of the backup file to restore: " container

# Find the latest backup for the specified container
BACKUP_FILE=$(ls -t "$BACKUP_DIR" | grep "^${container}_backup_" | head -n 1)

if [ -z "$BACKUP_FILE" ]; then
    echo "[$TIMESTAMP] No backup found for container: $container" | tee -a "$LOG_FILE"
    exit 1
fi

echo "[$TIMESTAMP] Restoring $container from: $BACKUP_FILE" | tee -a "$LOG_FILE"

# Restore the container
docker import "$BACKUP_DIR/$BACKUP_FILE" "$container:restored"

# Run the restored container
docker run -d --name "$container" "$container:restored"

if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP] Successfully restored container: $container" | tee -a "$LOG_FILE"
else
    echo "[$TIMESTAMP] Error restoring container: $container" | tee -a "$LOG_FILE"
    exit 1
fi

# Restore volumes if available
VOLUME_BACKUPS=$(ls "$BACKUP_DIR" | grep "^${container}_volume_")

if [ -n "$VOLUME_BACKUPS" ]; then
    for vol_backup in $VOLUME_BACKUPS; do
        tar -xzf "$BACKUP_DIR/$vol_backup" -C /
        if [ $? -eq 0 ]; then
            echo "[$TIMESTAMP] Successfully restored volume: $vol_backup" | tee -a "$LOG_FILE"
        else
            echo "[$TIMESTAMP] Error restoring volume: $vol_backup" | tee -a "$LOG_FILE"
        fi
    done
else
    echo "[$TIMESTAMP] No volume backups found for: $container" | tee -a "$LOG_FILE"
fi

echo "[$TIMESTAMP] Docker restore completed!" | tee -a "$LOG_FILE"
exit 0


