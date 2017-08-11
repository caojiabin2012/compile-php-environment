#!/bin/bash 
if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd $(dirname $0); pwd -P)
fi
source $prj_path/config.sh
package=$prj_path/package
echo -e nginx start `date`  >> install.log

# openssl
echo "install openssl:"
yum install openssl openssl-devel -y

if [ ! -d "$NGINX_PATH" ]; then
	mkdir -p $NGINX_PATH
fi

if [ ! -d "$package/nginx" ]; then
	mkdir $package/nginx
fi
rm -rf $package/nginx/*
wget -O $package/nginx.tar.gz $NGINX_DOWNLOAD_URL 

tar -zxvf $package/nginx.tar.gz -C $package/nginx/ --strip-components 1 
cd $package/nginx 
./configure --prefix=$NGINX_PATH --user=root --with-pcre --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module
make install
if [ $? == 0 ]; then
    echo -e nginx install success. `date` >> install.log
else
    echo -e nginx install fail. `date` >> install.log
fi
echo -e nginx end `date` >> install.log
