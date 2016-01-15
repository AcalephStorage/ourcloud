# Owncloud - Minio External Storage


By default Owncloud uses signature version 2 in authenticating to AWS api service. It can only be overridden to use v4 if region set is either ``eu-central-*`` or ``cn-*``. Minio in contrary only supports version 4 and only validates ``us-east-1`` / ``US`` region (at least for now). So a quick fix to go around this issue is to let Owncloud use signature v4 if the region set is `us-east-1`.

However this may require another modification if Minio decided to support any other regions aside from the existing one. A much better approach maybe is to add a flag or an option to trigger it's backend service to use the appropriate signature version, perhaps a checkbox in it's GUI and then update the backend service accordingly.

## Description:

Updated the official Ownclouds docker image to use signature version 4 in authenticating to AWS S3 api service if region set is `us-east-1`.

## Modifications:
~~~
         $requiresV4 = !$currentValue
             && isset($config['region'])
             && (strpos($config['region'], 'eu-central-') === 0
-                || strpos($config['region'], 'cn-') === 0);
+                || strpos($config['region'], 'cn-') === 0
+                || strpos($config['region'], 'us-east-') === 0);
~~~


## Installation:
~~~
$ docker build -t owncloud/minio .
$ docker run -d -p 80:80 owncloud/minio:latest
~~~

Or pull from quay.io

~~~
docker pull quay.io/acaleph/owncloud:latest
docker run -d -p 80:80 quay.io/acaleph/owncloud:latest
~~~

## Configuring Owncloud to Use Minio:

First, need to enable the External storage support module/app. Should be at Apps > Not enabled > External Storage Support. Then under Admin page, `Enable User External Storage` should be checked and then configure `External storage` (Amazon S3 type). For more details please check on the following links:


- [Enabling external storage support module/app](https://doc.owncloud.org/server/7.0/admin_manual/configuration/external_storage_configuration_gui.html#enabling-external-storage-support)
- [Adding external storage](https://doc.owncloud.org/server/7.0/admin_manual/configuration/external_storage_configuration_gui.html#amazon-s3)

## Example:
```
Folder name: Minio 
External storage type: Amazon S3
Bucket: myBucket
Hostname: minio.public.fqdn
Port: 12345
Region: us-east-1
Enable Path Style: (checked)
Access Key: S2M7XKJ1U***********
Secret Key: nUSjs2eGnvWi9kX4zzIBAoL*****************
```

If for instance `myBucket` is non-existent, then it will be created automatically.
Hostname could also be the associated domain name of the `minio` service while port is the internal port. Thus it could be changed to:

```
...
Hostname: minio-internal
Port: 9000
..
.
```

