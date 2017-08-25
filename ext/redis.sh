#!bin/bash
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/base.sh

package=$prj_path/package

ensure_dir "$package/redis"
remove_dir "$package/redis/*"
if [ ! -f "$package/redis-$PHP_EXT_REDIS_VERSION.tgz" ]; then
    wget -O $package/redis-$PHP_EXT_REDIS_VERSION.tgz $PHP_EXT_REDIS_DOWNLOAD_URL 
fi

tar -zxvf $package/redis-$PHP_EXT_REDIS_VERSION.tgz -C $package/redis/ --strip-components 1
cd $package/redis 
if [ -f "$PHP_PATH/bin/phpize" ]; then
    $PHP_PATH/bin/phpize
    ./configure --with-php-config=$PHP_PATH/bin/php-config
else
    phpize
    ./configure
fi
make install
if [ $? == 0 ]; then
    run_cmd "`echo -e extension=redis.so >> $PHP_CONFIG_PATH/php.ini`" 
    echo -e redis install success. `date` >> $prj_path/install.log
else
    echo -e redis install fail. `date` >> $prj_path/install.log
fi
