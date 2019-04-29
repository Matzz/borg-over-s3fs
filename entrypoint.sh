#!/bin/bash
set -e -o pipefail
BACKUPS_DIR=/mnt/backups

export S3_MOUNTPOINT="/mnt/s3fs"
export BORK_REPO_NAME="${BORK_REPO_NAME:-backup}"
export BORG_REPO="${S3_MOUNTPOINT}/${BORK_REPO_NAME}"

/mount-s3fs.sh

# Default archive from pschiffe/borg contain hostname which is useless in docker
export ARCHIVE="${ARCHIVE:-$(date +%Y-%m-%d--%H-%M-%S)}"
/borg-backup.sh