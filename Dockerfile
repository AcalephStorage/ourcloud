FROM owncloud:latest

COPY S3Client.php /usr/src/owncloud/apps/files_external/3rdparty/aws-sdk-php/Aws/S3/S3Client.php
