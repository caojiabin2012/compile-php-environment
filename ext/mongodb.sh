#!bin/bash
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/base.sh

package=$prj_path/package
ensure_dir "$package/mongodb"
remove_dir "$package/mongodb/*"
if [ ! -f "$package/mongodb-$PHP_EXT_MONGODB_VERSION.tgz" ]; then
    wget -O $package/mongodb-$PHP_EXT_MONGODB_VERSION.tar $PHP_EXT_MONGODB_DOWNLOAD_URL 
fi
tar -zxvf $package/mongodb-$PHP_EXT_MONGODB_VERSION.tar -C $package/mongodb/ --strip-components 1
cd $package/mongodb 
if [ -f "$PHP_PATH/bin/phpize" ]; then
    $PHP_PATH/bin/phpize
    ./configure --with-php-config=$PHP_PATH/bin/php-config
else
    phpize
    ./configure
fi
make install 
if [ $? == 0 ]; then
    run_cmd "`echo -e extension=mongodb.so >> $PHP_CONFIG_PATH/php.ini`" 
    echo -e mongodb install success. `date` >> $prj_path/install.log
else
    echo -e mongodb install fail. `date` >> $prj_path/install.log
fi
