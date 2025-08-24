#!/bin/bash

# Directories and filenames
SRC_DIR="/var/www/html/blog"
TMP_BACKUP="/backup"
BACKUP_NAME="xfusioncorp_blog.zip"
DEST_BACKUP="/backup"
USER="clint"             # Replace with correct Backup Server user
BACKUP_SERVER="stbkp01"    # Replace with actual hostname or IP

# Ensure zip is installed
if ! command -v zip &> /dev/null
then
    echo "zip not found, installing..."
    sudo yum install -y zip 2>/dev/null || sudo apt-get install -y zip
fi

# Verify source directory
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Source directory $SRC_DIR does not exist!"
    exit 1
fi

# Create backup directory if not exists
sudo mkdir -p $TMP_BACKUP

# Create zip archive
echo "Creating archive..."
sudo zip -r ${TMP_BACKUP}/${BACKUP_NAME} $SRC_DIR >/dev/null

# Check if archive was created
if [ ! -f "${TMP_BACKUP}/${BACKUP_NAME}" ]; then
    echo "Error: Failed to create archive at ${TMP_BACKUP}/${BACKUP_NAME}"
    exit 1
fi

# Ensure no permission issues
sudo chown $(whoami):$(whoami) ${TMP_BACKUP}/${BACKUP_NAME}

# Copy archive to Backup Server
echo "Copying archive to Nautilus Backup Server..."
scp ${TMP_BACKUP}/${BACKUP_NAME} ${USER}@${BACKUP_SERVER}:${DEST_BACKUP}/

# Verify copy
if ssh ${USER}@${BACKUP_SERVER} "[ -f ${DEST_BACKUP}/${BACKUP_NAME} ]"; then
    echo "Backup successfully copied to Nautilus Backup Server!"
else
    echo "Backup failed!"
    exit 1
fi
