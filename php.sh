#!/bin/bash 
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd $(dirname $0); pwd -P)
fi
source $prj_path/config.sh
package=$prj_path/package
echo -e php start `date`  >> install.log

if which yum >/dev/null; then
    # xml
    yum install -y libxml2 libxml2-devel

    # curl
    yum install -y curl curl-devel

    # openssl
    yum install -y openssl openssl-devel

    # GD
    yum install -y libjpeg libjpeg-devel
    yum install -y libpng libpng-devel

    # mcrypt
    yum install -y libmcrypt libmcrypt-devel

    yum install -y m4 autoconf

elif which apt-get >/dev/null; then
    # xml
    apt-get install -y libxml2-dev

    # curl 
    apt-get install -y libcurl4-openssl-dev

    # openssl
    apt install -y libltdl-dev libssl-dev

    # GD
    apt-get install -y libjpeg-dev
    apt-get install -y libpng-dev 

    # mcrypt
    #apt-get install -y libmcrypt-dev
    apt-get install -y m4 autoconf

elif which brew >/dev/null; then
    echo "Darwin"
fi

if [ ! -d "$package/php" ]; then
	mkdir -p $package/php
fi
rm -rf $package/php/*
wget -O $package/php.tar.bz2 ${PHP_DOWNLOAD_URL} 

tar -jxvf $package/php.tar.bz2 -C $package/php/ --strip-components 1
cd $package/php 
./configure  --prefix=$PHP_PATH --with-config-file-path=$PHP_CONFIG_PATH --enable-fpm --enable-pcntl --enable-mysqlnd --enable-opcache --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-shmop --enable-zip --enable-ftp --enable-soap --enable-xml --enable-mbstring --disable-rpath --disable-debug --disable-fileinfo --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pcre-regex --with-iconv --with-zlib --with-mhash --with-xmlrpc --with-curl --with-imap-ssl --enable-bcmath --enable-fileinfo
make install
if [ $? == 0 ]; then
    cp php.ini-production $PHP_CONFIG_PATH/php.ini
    mv $PHP_PATH/etc/php-fpm.conf.default $PHP_PATH/etc/php-fpm.conf
    mv $PHP_PATH/etc/php-fpm.d/www.conf.default $PHP_PATH/etc/php-fpm.d/www.conf 
    echo -e php install success. `date` >> install.log
else
    echo -e php install fail. `date` >> install.log
fi
echo -e php end `date` >> install.log
