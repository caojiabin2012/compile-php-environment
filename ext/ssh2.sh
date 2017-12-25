#!bin/bash
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/base.sh

package=$prj_path/package

if which yum >/dev/null; then
    # ssh2 
    yum install -y libssh2 libssh2-devel
    
elif which apt-get >/dev/null; then
    # ssh2 
    apt-get install -y libssh2-1-dev

elif which brew >/dev/null; then
    echo "Darwin"
fi
ensure_dir "$package/ssh2"
remove_dir "$package/ssh2/*"
if [ ! -f "$package/ssh2-$PHP_EXT_SSH2_VERSION.tgz" ]; then
    wget -O $package/ssh2-$PHP_EXT_SSH2_VERSION.tgz $PHP_EXT_SSH2_DOWNLOAD_URL 
fi

tar -zxvf $package/ssh2-$PHP_EXT_SSH_VERSION.tgz -C $package/ssh2/ --strip-components 1
cd $package/ssh2 
if [ -f "$PHP_PATH/bin/phpize" ]; then
    $PHP_PATH/bin/phpize
    ./configure --with-php-config=$PHP_PATH/bin/php-config
else
    phpize
    ./configure
fi
make install
if [ $? == 0 ]; then
    run_cmd "`echo -e extension=ssh2.so >> $PHP_CONFIG_PATH/php.ini`" 
    echo -e ssh2 install success. `date` >> $prj_path/install.log
else
    echo -e ssh2 install fail. `date` >> $prj_path/install.log
fi
