# Docker Backup & Restore Scripts

Automated backup and restore scripts for Docker containers and their volumes.

## Features  
- **Automated Backups:** Exports running container filesystems and volumes.  
- **Efficient Storage:** Compresses backups to save space.  
- **Restore Support:** Easily imports backups and recreates containers.  
- **Logging:** Tracks successes and failures for troubleshooting.  
- **Cron Job Ready:** Automate backups with scheduled tasks.  

---

## Getting Started  

### 1. Clone the Repository  
```bash
git clone https://github.com/your-username/docker-backup-restore.git
cd docker-backup-restore
```

### 2. Make Scripts Executable
```bash
chmod +x docker-backup.sh docker-restore.sh
```

### 3. Customize the .env files: 
1. Open `docker-backup.env` and `docker-restore.env`.
2. Replace the placeholder paths with your actual paths:
   - `BACKUP_DIR`: Directory to store backups.
   - `LOG_DIR`: Directory to store log files.
   - `VOLUME_DIR` (optional): Directory to restore volumes.
3. Ensure the directories exist:
   ```bash
   mkdir -p /path/to/backups
   mkdir -p /path/to/logs

## Usage
### Backup All Running Containers
```bash
./docker-backup.sh
```
- Saves container filesystems & mounted volumes.
- Stores backups in ~/docker-backup-restore/backups/ by default.

### Restore a Container from Backup
```bash
./docker-restore.sh
```
- Lists available backups. 
- Prompts for container name & restores it.

## Automate Backups with Cron
To run the backup daily at 2AM:
1. Open the crontab editor:
```bash
crontab -e
```
2. Add this line at the bottom:
```bash
0 2 * * * $HOME/docker-backup-restore/docker-backup.sh >> $HOME/docker-backup-restore/cron.log 2>&1
```
3. Save and exit.

## Planned Enhancements
- [] Integrate with Jenkins for automated scheduling.
- [] Convert to a Python script for better logging & notifications. 
- [] Use Ansible for deployment across multiple servers. 

## Contributing
Feel free to submit a pull request with improvements or additional features!