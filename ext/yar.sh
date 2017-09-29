#!bin/bash
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/base.sh

package=$prj_path/package

ensure_dir "$package/yar"
remove_dir "$package/yar/*"
if [ ! -f "$package/yar-$PHP_EXT_YAR_VERSION.tgz" ]; then
    wget -O $package/yar-$PHP_EXT_YAR_VERSION.tgz ${PHP_EXT_YAR_DOWNLOAD_URL} 
fi
tar -zxvf $package/yar-$PHP_EXT_YAR_VERSION.tgz -C $package/yar/ --strip-components 1
cd $package/yar 
if [ -f "$PHP_PATH/bin/phpize" ]; then
    $PHP_PATH/bin/phpize
    ./configure --with-php-config=$PHP_PATH/bin/php-config
else
    phpize
    ./configure
fi
make install 
if [ $? == 0 ]; then
    run_cmd "`echo -e extension=yar.so >> $PHP_CONFIG_PATH/php.ini`"
    echo -e yar install success. `date` >> $prj_path/install.log
else
    echo -e yar install fail. `date` >> $prj_path/install.log
fi
