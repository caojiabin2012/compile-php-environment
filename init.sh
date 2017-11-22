#!bin/bash
set -e

echo -e "*****************************************" > install.log
echo -e "*   Author:caojiabin2012@gmail.com      *" >> install.log
echo -e "*****************************************" >> install.log
prj_path=$(cd $(dirname $0); pwd -P)

source $prj_path/config.sh
# kill
#ps -ef | grep php-fpm| grep -v grep|awk '{print $2}' | xargs kill -9
#ps -ef | grep nginx| grep -v grep|awk '{print $2}' | xargs kill -9

# install php ext
for ext_file in ext/*
do
    if test -f $ext_file
    then
        bash $ext_file
    fi
done

# start server
$NGINX_PATH/sbin/nginx
$PHP_PATH/sbin/php-fpm
