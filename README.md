# Borg over s3fs
Image based on pschiffe/borg

## Setup
Following examples do not support encryption. For encrypted Borg repo add relevant environment variables described in https://github.com/pschiffe/docker-borg
The examples use 4 docker volumes to keep borg and s3fs cache between calls. It significantly reduces backup costs. 

### Create repository and archive

```
docker run --privileged \
-e "S3_BUCKET=[REPLACE_WITH_BUCKET_NAME]" \
-e "AWS_ACCESS_KEY_ID=[REPLACE_WITH_AWS_KEY \
-e "AWS_SECRET_ACCESS_KEY=[REPLACE_WITH_AWS_SECRET]" \
-e "BACKUP_DIRS=/to-backup/." \
-e "S3FS_ARGS=-ouse_cache=/root/.cache/s3fs-cache" \
-v s3fs-backup-cache:/root/.cache/s3fs-cache \
-v borg-archive:/root/.cache/borg \
-v borg-config:/root/.config/borg \
-v $(pwd)/source_test:/to-backup \
bs3test
```


### Restore archive
```
docker run --privileged \
-e "S3_BUCKET=[REPLACE_WITH_BUCKET_NAME]" \
-e "AWS_ACCESS_KEY_ID=[REPLACE_WITH_AWS_KEY \
-e "AWS_SECRET_ACCESS_KEY=[REPLACE_WITH_AWS_SECRET]" \
-e "EXTRACT_TO=/to_restore" \
-e "BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes" \
-e "ARCHIVE=2019-04-29--11-12-13" \
-v $(pwd)/restored:/to_restore \
bs3test
```


### List archive
```
docker run --privileged \
-e "S3_BUCKET=[REPLACE_WITH_BUCKET_NAME]" \
-e "AWS_ACCESS_KEY_ID=[REPLACE_WITH_AWS_KEY \
-e "AWS_SECRET_ACCESS_KEY=[REPLACE_WITH_AWS_SECRET]" \
-e BORG_PARAMS='list ::2019-04-29--11-12-13' \
-e "BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes" \
bs3test
```