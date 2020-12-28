#!/bin/bash
if [ `date +%H:%M` == "23:50" ]
then
    FILE_NAME=$(date +"%Y%m%d%H%M")
    mysqldump --user $OPENSHIFT_MYSQL_DB_USERNAME -p$OPENSHIFT_MYSQL_DB_PASSWORD --host $OPENSHIFT_MYSQL_DB_HOST $BACKUP_DATABASE_NAME > $OPENSHIFT_DATA_DIR/$FILE_NAME.sql
    echo "Took MySQL Dump" >> $OPENSHIFT_CRON_DIR/log/backup.log
    $OPENSHIFT_DATA_DIR/s3-bash/s3-put -k $AWS_ACCESS_KEY_ID -s $OPENSHIFT_DATA_DIR/s3-bash/AWSSecretAccessKeyIdFile -T $OPENSHIFT_DATA_DIR/$FILE_NAME.sql /$AWS_S3_BUCKET/$FILE_NAME.sql
    echo "Uploaded dump to Amazon S3" >> $OPENSHIFT_CRON_DIR/log/backup.log
    rm -f $OPENSHIFT_DATA_DIR/$FILE_NAME.sql
fi