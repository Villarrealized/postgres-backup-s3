#! /bin/sh

set -e

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

echo "$SCHEDULE backup.sh >> /var/log/backup.log" > crontab.txt

# Add crontab
/usr/bin/crontab crontab.txt

# start cron
/usr/sbin/crond -f -l 8
