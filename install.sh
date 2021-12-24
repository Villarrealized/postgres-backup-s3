#! /bin/sh

# exit if a command fails
set -e

apk update

# install tzdata to enable TZ env variable
apk add tzdata

# install s3 tools
apk add python py2-pip
pip install awscli
apk del py2-pip


# cleanup
rm -rf /var/cache/apk/*
