#!bin/bash
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
package=$prj_path/package

if [ ! -d "$package/redis" ]; then
    mkdir -p $package/redis
fi
rm -rf $package/redis/*
if [ ! -f '$package/redis-$PHP_EXT_REDIS_VERSION.tgz' ]; then
    wget -O $package/redis-$PHP_EXT_REDIS_VERSION.tgz $PHP_EXT_REDIS_DOWNLOAD_URL 
fi

tar -zxvf $package/redis-$PHP_EXT_REDIS_VERSION.tgz -C $package/redis/ --strip-components 1
cd $package/redis 
$PHP_PATH/bin/phpize
./configure --with-php-config=$PHP_PATH/bin/php-config
make install
if [ $? == 0 ]; then
    echo -e extension=redis.so >> $PHP_CONFIG_PATH/php.ini 
    echo -e redis install success. `date` >> $prj_path/install.log
else
    echo -e redis install fail. `date` >> $prj_path/install.log
fi
