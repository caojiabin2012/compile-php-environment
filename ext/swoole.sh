#!bin/bash
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/base.sh

package=$prj_path/package
libs=$prj_path/libs

ensure_dir "$package/hiredis"
remove_dir "$package/hiredis/*"
if [ ! -f "$package/hiredis-$LIB_HIREDIS_VERSION.tgr.gz" ]; then
    wget -O $package/hiredis-$LIB_HIREDIS_VERSION.tgr.gz $LIB_HIREDIS_DOWNLOAD_URL 
fi

tar -zxvf $package/hiredis-$LIB_HIREDIS_VERSION.tgr.gz -C $package/hiredis/ --strip-components 1
cd $package/hiredis 
make -j
sudo make install
sudo ldconfig

ensure_dir "$package/swoole"
remove_dir "$package/swoole/*"
if [ ! -f "$package/swoole-$PHP_EXT_SWOOLE_VERSION.tgz" ]; then
    wget -O $package/swoole-$PHP_EXT_SWOOLE_VERSION.tgz $PHP_EXT_SWOOLE_DOWNLOAD_URL 
fi

tar -zxvf $package/swoole-$PHP_EXT_SWOOLE_VERSION.tgz -C $package/swoole/ --strip-components 1
cd $package/swoole 
$PHP_PATH/bin/phpize
./configure --with-php-config=$PHP_PATH/bin/php-config --enable-openssl --enable-sockets --enable-async-redis --enable-mysqlnd
make install
if [ $? == 0 ]; then
    run_cmd "`echo -e extension=swoole.so >> $PHP_CONFIG_PATH/php.ini`" 
    echo -e swoole install success. `date` >> $prj_path/install.log
else
    echo -e swoole install fail. `date` >> $prj_path/install.log
fi
