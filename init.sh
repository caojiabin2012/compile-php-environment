#!bin/bash
set -e

echo -e "*****************************************" > install.log
echo -e "*   Author:caojiabin2012@gmail.com      *" >> install.log
echo -e "*****************************************" >> install.log
prj_path=$(cd $(dirname $0); pwd -P)

# kill
ps -ef | grep php-fpm| grep -v grep|awk '{print $2}' | xargs kill -9
ps -ef | grep nginx| grep -v grep|awk '{print $2}' | xargs kill -9

# install
bash nginx.sh
bash php.sh
bash ext/redis.sh
bash ext/mongodb.sh
bash ext/yaf.sh
bash ext/swoole.sh

# start server
$NGINX_PATH/sbin/nginx
$PHP_PATH/sbin/php-fpm
