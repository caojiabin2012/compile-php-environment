#!/bin/bash 
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd $(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/bash.sh

package=$prj_path/package

# openssl
if which yum >/dev/null; then
    run_cmd "yum install -y openssl openssl-devel"
elif which apt-get >/dev/null; then
    apt install -y libltdl-dev libssl-dev libpcre3 libpcre3-dev
elif which brew >/dev/null; then
    echo "Darwin"
fi

ensure_dir "$NGINX_PATH"
ensure_user "$NGINX_USER"
ensure_dir "$package/nginx"
rm -rf $package/nginx/*
if [ ! -f "$package/nginx-$NGINX_VERSION.tar.gz" ]; then
    wget -O $package/nginx-$NGINX_VERSION.tar.gz $NGINX_DOWNLOAD_URL 
fi

tar -zxvf $package/nginx-$NGINX_VERSION.tar.gz -C $package/nginx/ --strip-components 1 
cd $package/nginx 
./configure --prefix=$NGINX_PATH --user=$NGINX_USER --with-pcre --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module
make install
if [ $? == 0 ]; then
    echo -e "<?php phpinfo();"  > $NGINX_PATH/html/index.php 
    cp -rf $prj_path/nginx-config/* $NGINX_PATH/
    #sed -i "s/{{NGINX_LISTEN_PORT}}/$NGINX_LISTEN_PORT/" $NGINX_PATH/conf/nginx.conf
    #sed -i "s/{{PHP_FASTCGI_LISTEN_PORT}}/$PHP_FASTCGI_LISTEN_PORT/" $NGINX_PATH/conf/nginx.conf
    run_cmd "`sed -i "s/{{PHP_FASTCGI_LISTEN_PORT}}/$PHP_FASTCGI_LISTEN_PORT/" $NGINX_PATH/conf/nginx.conf`"
    run_cmd "`sed -i "s/{{NGINX_LISTEN_PORT}}/$NGINX_LISTEN_PORT/" $NGINX_PATH/conf/nginx.conf`"
else
    echo -e nginx install fail. `date` >> install.log
fi
