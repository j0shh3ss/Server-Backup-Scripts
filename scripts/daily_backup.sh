#!/bin/bash

set -euo pipefail

SOURCE_DIR="/mnt/server/minecraft/backups/hourly"
DEST_DIR="/mnt/server/minecraft/backups/daily"
LOG_DIR="/mnt/server/minecraft/backups/logs"

# Ensure destination exists
mkdir -p "$DEST_DIR" "$LOG_DIR"

# Timestamp for backup filename
TIMESTAMP=$(date +"%Y-%m-%d")

# Copy the latest backup from hourly
# You can rename "world" in the output filename if desired.
# This does NOT affect what gets backed up.
LATEST_BACKUP=$(find "$SOURCE_DIR" -type f -printf '%T@ %p\n' | sort -nr | head -n 1 | cut -d' ' -f2-)
if [ -z "$LATEST_BACKUP" ]; then
  echo "No backups found in $SOURCE_DIR"
  exit 1
fi
cp "$LATEST_BACKUP" "$DEST_DIR/world_daily_$TIMESTAMP.tar.zst"

# Delete daily backups older than 7 days, can change, increment 7 to change how long you want to keep daily backups
find "$DEST_DIR" -type f -name "*.tar.zst" -mtime +7 -exec rm {} \;

# Optional log
echo "$(date): Daily backup completed." >> "$LOG_DIR/backup_daily.log"