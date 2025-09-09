FROM postgres:12.13

# Install required packages
RUN apt-get update && apt-get install -y \
    tzdata \
    curl \
    cron \
    unzip \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Default ENV values (overridden by docker-compose env_file)
ENV POSTGRES_DATABASE **None**
ENV POSTGRES_HOST **None**
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER **None**
ENV POSTGRES_PASSWORD **None**
ENV POSTGRES_EXTRA_OPTS ''
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_PATH 'backup'
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV SCHEDULE '0 0 * * *'

# Add scripts
ADD run.sh /run.sh
ADD backup.sh /backup.sh

RUN chmod 755 /run.sh /backup.sh

CMD ["/bin/bash", "/run.sh"]
