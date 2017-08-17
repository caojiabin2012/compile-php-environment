#!bin/bash
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/base.sh

package=$prj_path/package

ensure_dir "$package/yaf"
remove_dir "$package/yaf/*"
if [ ! -f "$package/yaf-$PHP_EXT_YAF_VERSION.tgz" ]; then
    wget -O $package/yaf-$PHP_EXT_YAF_VERSION.tgz ${PHP_EXT_YAF_DOWNLOAD_URL} 
fi
tar -zxvf $package/yaf-$PHP_EXT_YAF_VERSION.tgz -C $package/yaf/ --strip-components 1
cd $package/yaf 
$PHP_PATH/bin/phpize
./configure --with-php-config=$PHP_PATH/bin/php-config
make install 
if [ $? == 0 ]; then
    run_cmd "`echo -e extension=yaf.so >> $PHP_CONFIG_PATH/php.ini`"
    echo -e yaf install success. `date` >> $prj_path/install.log
else
    echo -e yaf install fail. `date` >> $prj_path/install.log
fi
