#!/bin/bash
set -e
set -o pipefail

: "${S3_ACCESS_KEY_ID:?Need to set S3_ACCESS_KEY_ID}"
: "${S3_SECRET_ACCESS_KEY:?Need to set S3_SECRET_ACCESS_KEY}"
: "${S3_BUCKET:?Need to set S3_BUCKET}"
: "${POSTGRES_DATABASE:?Need to set POSTGRES_DATABASE}"
: "${POSTGRES_HOST:?Need to set POSTGRES_HOST}"
: "${POSTGRES_USER:?Need to set POSTGRES_USER}"
: "${POSTGRES_PASSWORD:?Need to set POSTGRES_PASSWORD}"

POSTGRES_PORT=${POSTGRES_PORT:-5432}
AWS_ARGS=""
[ "$S3_ENDPOINT" != "**None**" ] && AWS_ARGS="--endpoint-url $S3_ENDPOINT"
export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=${S3_REGION:-us-east-1}
export PGPASSWORD=$POSTGRES_PASSWORD

echo "Creating dump of ${POSTGRES_DATABASE} from ${POSTGRES_HOST}..."
DUMP_FILE="/tmp/dump.sql.gz"
pg_dump -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" $POSTGRES_EXTRA_OPTS "$POSTGRES_DATABASE" | gzip > "$DUMP_FILE"

echo "Uploading dump to s3://$S3_BUCKET/$S3_PREFIX/"
aws $AWS_ARGS s3 cp "$DUMP_FILE" "s3://$S3_BUCKET/$S3_PREFIX/${POSTGRES_DATABASE}_$(date -u +"%Y-%m-%dT%H:%M:%SZ").sql.gz"

rm -f "$DUMP_FILE"
echo "SQL backup uploaded successfully"
