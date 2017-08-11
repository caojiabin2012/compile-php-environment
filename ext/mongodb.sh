#!bin/bash

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
package=$prj_path/package
if [ ! -d "$package/mongodb" ]; then
    mkdir -p $package/mongodb
fi
rm -rf $package/mongodb/*
wget -O $package/mongodb.tar $PHP_EXT_MONGODB_DOWNLOAD_URL 
tar -zxvf $package/mongodb.tar -C $package/mongodb/ --strip-components 1
cd $package/mongodb 
${PHP_PATH}/bin/phpize
./configure --with-php-config=${PHP_PATH}/bin/php-config
make install 
if [ $? == 0 ]; then
    echo -e extension=mongodb.so >> $PHP_CONFIG_PATH/php.ini 
    echo -e mongodb install success. `date` >> $prj_path/install.log
else
    echo -e mongodb install fail. `date` >> $prj_path/install.log
fi
