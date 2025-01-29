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



## Planned Enhancements
- [] Integrate with Jenkins for automated scheduling.
- [] Convert to a Python script for better logging & notifications. 
- [] Use Ansible for deployment across multiple servers. 

## Contributing
Feel free to submit a pull request with improvements or additional features!