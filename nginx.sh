#!/bin/bash 
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd $(dirname $0); pwd -P)
fi
source $prj_path/config.sh
package=$prj_path/package
echo -e nginx start `date`  >> install.log

# openssl
if which yum >/dev/null; then
    yum install -y openssl openssl-devel
elif which apt-get >/dev/null; then
    apt install -y libltdl-dev libssl-dev libpcre3 libpcre3-dev
elif which brew >/dev/null; then
    echo "Darwin"
fi

if [ ! -d "$NGINX_PATH" ]; then
    mkdir -p $NGINX_PATH
fi

if [ ! -d "$package/nginx" ]; then
    mkdir -p $package/nginx
fi
rm -rf $package/nginx/*
if [ ! -f `$package/nginx-$NGINX_VERSION.tar.gz`]; then
    wget -O $package/nginx-$NGINX_VERSION.tar.gz $NGINX_DOWNLOAD_URL 
fi

tar -zxvf $package/nginx-$NGINX_VERSION.tar.gz -C $package/nginx/ --strip-components 1 
cd $package/nginx 
./configure --prefix=$NGINX_PATH --user=root --with-pcre --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module
make install
if [ $? == 0 ]; then
    echo -e "<?php phpinfo();"  > $NGINX_PATH/html/index.php 
    rm $NGINX_PATH/conf/nginx.conf
    cp $prj_path/nginx-config/nginx.conf $NGINX_PATH/conf/
else
    echo -e nginx install fail. `date` >> install.log
fi
