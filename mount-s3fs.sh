#!/usr/bin/env bash
set -e -o pipefail


[ "${DEBUG:-false}" == 'true' ] && { S3FS_DEBUG='-d -d'; }

# Defaults
: ${AWS_S3_AUTHFILE:='/root/.s3fs'}
: ${AWS_S3_MOUNTPOINT:='/mnt'}
: ${S3FS_ARGS:=''}


if [ -z "$S3_BUCKET" ]; then    echo "Error: S3_BUCKET is not specified"
    exit 128
fi
if [ -z "$S3_MOUNTPOINT" ]; then
    echo "Error: S3_MOUNTPOINT is not specified"
    exit 128
fi

# Write auth file if it does not exist and AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY pair is not empty
if [ ! -f "${AWS_S3_AUTHFILE}" ] && [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
   echo "${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}" > ${AWS_S3_AUTHFILE}
   chmod 400 ${AWS_S3_AUTHFILE}
   CMD_AUTH_FILE="-o passwd_file=${AWS_S3_AUTHFILE}"
fi

# Set IAM role if specified
if [ -n "$IAM_ROLE" ]; then
   CMD_IAM_ROLE="-o iam_role=${IAM_ROLE}"
fi

echo "Mounting S3 bucket ${S3_BUCKET} to ${S3_MOUNTPOINT}"
mkdir -p ${S3_MOUNTPOINT}

s3fs ${S3_BUCKET} ${S3_MOUNTPOINT} $S3FS_DEBUG $CMD_AUTH_FILE $CMD_IAM_ROLE $S3FS_ARGS
