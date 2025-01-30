#!/bin/bash

# Define directories and log file
 BACKUP_DIR="$HOME/docker-backup-restore/backups"
 LOG_DIR="$HOME/docker-backup-restore/logs"
 LOG_FILE="$LOG_DIR/backup.log"
 mkdir -p "$BACKUP_DIR" # Ensure the backup directory exists
 mkdir -p "$LOG_DIR" # Ensure the log directory exists

 # Define timestamp
 TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
 echo "[$TIMESTAMP] Starting Docker backup..." | tee -a "$LOG_FILE"

# Backup each running container
  # Check if there are any running containers
    CONTAINERS=$(docker ps --format "{{.Names}}")

    if [ -z "$CONTAINERS" ]; then
        echo "[$TIMESTAMP] No running containers found. Exiting..." | tee -a "$LOG_FILE"
        exit 0
    fi

  # Loop through & backup each running container
    for container in $CONTAINERS; do
        echo "[$TIMESTAMP] Backing up container: $container" | tee -a "$LOG_FILE"
        
        BACKUP_FILE="$BACKUP_DIR/${container}_backup_$TIMESTAMP.tar.gz"
        docker export "$container" | gzip > "$BACKUP_FILE"

        if [ $? -eq 0 ]; then
            echo "[$TIMESTAMP] Successfully backed up: $BACKUP_FILE" | tee -a "$LOG_FILE"
        else
            echo "[$TIMESTAMP] Error backing up: $container" | tee -a "$LOG_FILE"
            continue
        fi

      # Backup mounted volumes (if any)
        VOLUMES=$(docker inspect -f '{{ range .Mounts }}{{ .Source }} {{ end }}' "$container")
        
        if [ -n "$VOLUMES" ]; then
            for vol in $VOLUMES; do
                vol_name=$(basename "$vol")
                VOL_BACKUP_FILE="$BACKUP_DIR/${container}_volume_${vol_name}_$TIMESTAMP.tar.gz"
                tar -czf "$VOL_BACKUP_FILE" "$vol"

                if [ $? -eq 0 ]; then
                    echo "[$TIMESTAMP] Successfully backed up volume: $VOL_BACKUP_FILE" | tee -a "$LOG_FILE"
                else
                    echo "[$TIMESTAMP] Error backing up volume: $vol" | tee -a "$LOG_FILE"
                fi
            done
        else
            echo "[$TIMESTAMP] No volumes found for container: $container" | tee -a "$LOG_FILE"
        fi
    done

    echo "[$TIMESTAMP] Docker backup completed!" | tee -a "$LOG_FILE"
    exit 0
