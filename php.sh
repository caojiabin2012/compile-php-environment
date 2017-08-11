#!/bin/bash 
if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd $(dirname $0); pwd -P)
fi
source $prj_path/config.sh
package=$prj_path/package
echo -e php start `date`  >> install.log

# xml
echo "install xml:"
yum install libxml2 libxml2-devel -y

# curl
echo "install curl:"
yum install curl curl-devel -y

# openssl
echo "install openssl:"
yum install openssl openssl-devel -y

# GD
yum install libjpeg libjpeg-devel -y
yum install libpng libpng-devel y

if [ ! -d "$package/php" ]; then
	mkdir -p $package/php
fi
rm -rf $package/php/*
wget -O $package/php.tar.bz2 ${PHP_DOWNLOAD_URL} 

tar -jxvf $package/php.tar.bz2 -C $package/php/ --strip-components 1
cd $package/php 
./configure  --prefix=$PHP_PATH --with-config-file-path=$PHP_CONFIG_PATH --enable-fpm --enable-pcntl --enable-mysqlnd --enable-opcache --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-shmop --enable-zip --enable-ftp --enable-soap --enable-xml --enable-mbstring --disable-rpath --disable-debug --disable-fileinfo --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pcre-regex --with-iconv --with-zlib --with-mhash --with-xmlrpc --with-curl --with-imap-ssl --enable-bcmath --enable-fileinfo
make install
cp php.ini-production $PHP_CONFIG_PATH/php.ini
if [ $? == 0 ]; then
    echo -e php install success. `date` >> install.log
else
    echo -e php install fail. `date` >> install.log
fi
echo -e php end `date` >> install.log
