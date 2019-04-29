FROM pschiffe/borg:latest

# S3FS installation
RUN yum -y install s3fs-fuse

COPY entrypoint.sh /
COPY mount-s3fs.sh /

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]