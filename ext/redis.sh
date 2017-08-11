#!bin/bash
if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
package=$prj_path/package

if [ ! -d "$package/redis" ]; then
    mkdir -p $package/redis
fi
rm -rf $package/redis/*
wget -O $package/redis.tgz $PHP_EXT_REDIS_DOWNLOAD_URL 

tar -zxvf $package/redis.tgz -C $package/redis/ --strip-components 1
cd $package/redis 
$PHP_PATH/bin/phpize
./configure --with-php-config=$PHP_PATH/bin/php-config
make install
if [ $? == 0 ]; then
    echo -e redis install success. `date` >> install.log
else
    echo -e redis install fail. `date` >> install.log
fi
