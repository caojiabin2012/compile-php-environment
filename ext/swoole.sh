#!bin/bash
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/base.sh

package=$prj_path/package
libs=$prj_path/libs

cd $libs/hiredis/0.13.3
make -j
sudo make install
sudo ldconfig
make clean

ensure_dir "$package/swoole"
remove_dir "$package/swoole/*"
if [ ! -f "$package/yaf-$PHP_EXT_SWOOLE_VERSION.tgz" ]; then
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
