#!bin/bash
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/base.sh

package=$prj_path/package

ensure_dir "$package/yac"
remove_dir "$package/yac/*"
if [ ! -f "$package/yac-$PHP_EXT_YAC_VERSION.tgz" ]; then
    wget -O $package/yac-$PHP_EXT_YAC_VERSION.tgz ${PHP_EXT_YAC_DOWNLOAD_URL} 
fi
tar -zxvf $package/yac-$PHP_EXT_YAC_VERSION.tgz -C $package/yac/ --strip-components 1
cd $package/yac 
if [ -f "$PHP_PATH/bin/phpize" ]; then
    $PHP_PATH/bin/phpize
    ./configure --with-php-config=$PHP_PATH/bin/php-config
else
    phpize
    ./configure
fi
make install 
if [ $? == 0 ]; then
    run_cmd "`echo -e extension=yac.so >> $PHP_CONFIG_PATH/php.ini`"
    echo -e yac install success. `date` >> $prj_path/install.log
else
    echo -e yac install fail. `date` >> $prj_path/install.log
fi
