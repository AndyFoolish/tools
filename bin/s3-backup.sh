#!/bin/sh
# UTCOM Backup scripts
# To easily backup UTCOM Project
# Author: TualatriX

set -e
set -x
 
REMOTE_PATH="public_html/ubuntu-tweak.com"
PROJECT_NAME="utcom"
LOCAL_PATH="$HOME/Dropbox/$PROJECT_NAME-backup"
PRE=$PROJECT_NAME-`date +%F`
KERNEL=`uname -s`
 
if [ ! -e $LOCAL_PATH ]
then
	mkdir -p $LOCAL_PATH
fi

cd $LOCAL_PATH

cd $REMOTE_PATH; tar cf - --exclude '.git' $PROJECT_NAME | gzip > $PRE.tar.gz
tar zxvf $PRE.tar.gz $PROJECT_NAME/$PROJECT_NAME/local_settings.py
touch $PROJECT_NAME/$PROJECT_NAME/__init__.py

cd $LOCAL_PATH/$PROJECT_NAME
if [ -f $PROJECT_NAME/local_settings.py ];then
    if [ $KERNEL = "Darwin" ]; then
        gsed -i '/global_setting/d' $PROJECT_NAME/local_settings.py
    elif [ $KERNEL = "Linux" ]; then
        sed -i '/global_setting/d' $PROJECT_NAME/local_settings.py
    fi

    DB_NAME=`python -c "import $PROJECT_NAME.local_settings;print $PROJECT_NAME.local_settings.DATABASE_NAME"`
    DB_USER=`python -c "import $PROJECT_NAME.local_settings;print $PROJECT_NAME.local_settings.DATABASE_USER"`
    DB_PASSWORD=`python -c "import $PROJECT_NAME.local_settings;print $PROJECT_NAME.local_settings.DATABASE_PASSWORD"`
    rm -r $PROJECT_NAME
else
    echo "Something wrong ..."
    exit 1
fi

cd $LOCAL_PATH

mysqldump -u${DB_USER} -p${DB_PASSWORD} $DB_NAME | gzip > $PRE.sql.gz

s3cmd put $PRE.tar.gz s3://imtx/
s3cmd put $PRE.sql.gz s3://imtx/
