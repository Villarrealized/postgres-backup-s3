#!/bin/bash
set -e
set -o pipefail

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

# Dump all environment variables to a file for cron jobs
printenv | sed 's/^\(.*\)$/export \1/' > /container.env

# Create cron job file (source env before running backup)
echo "$SCHEDULE . /container.env; /backup.sh >> /var/log/backup.log 2>&1" > crontab.txt

# Install the crontab
crontab crontab.txt

# Ensure log file exists
touch /var/log/backup.log

echo "[Backup] Cron schedule set to: $SCHEDULE"
echo "[Backup] Starting cron in foreground..."

# Start cron
exec cron -f -l 8
