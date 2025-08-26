#!/bin/bash

# Create a zip archive of the official directory
zip -r /backup/xfusioncorp_official.zip /var/www/html/official

# Copy the archive to the backup server
scp /backup/xfusioncorp_official.zip clint@stbkp01:/backup/
