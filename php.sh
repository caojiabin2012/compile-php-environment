#!/bin/bash 
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd $(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/base.sh

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
    apt install -y m4 g++ make binutils autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev libc-ares-dev libjemalloc-dev libsystemd-dev libspdylay-dev

    # GD
    apt-get install -y libjpeg-dev
    apt-get install -y libpng-dev 
 

elif which brew >/dev/null; then
    echo "Darwin"
fi

# mcrypt
ensure_dir "$package/libmcrypt"
remove_dir "$package/libmcrypt/*"
if [ ! -f "$package/php-$PHP_VERION.tar.bz2" ]; then
    wget -O $package/libmcrypt.tar.gz ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz
fi
tar -zxvf $package/libmcrypt.tar.gz -C $package/libmcrypt/ --strip-components 1
cd $package/libmcrypt
./configure --prefix=/usr/local/libmcrypt
make && make install

ensure_user "$PHP_FPM_USER"
ensure_dir "$package/php"
remove_dir "$package/php/*"
if [ ! -f "$package/php-$PHP_VERION.tar.bz2" ]; then
    wget -O $package/php-$PHP_VERSION.tar.bz2 $PHP_DOWNLOAD_URL 
fi

tar -jxvf $package/php-$PHP_VERSION.tar.bz2 -C $package/php/ --strip-components 1
cd $package/php 
./configure  --prefix=$PHP_PATH --with-config-file-path=$PHP_CONFIG_PATH --with-mcrypt=/usr/local/libmcrypt --with-openssl --enable-fpm --enable-pcntl --enable-mysqlnd --enable-opcache --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-shmop --enable-zip --enable-ftp --enable-soap --enable-xml --enable-mbstring --disable-rpath --disable-debug --disable-fileinfo --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pcre-regex --with-iconv --with-zlib --with-mhash --with-xmlrpc --with-curl --with-imap-ssl --enable-bcmath --enable-fileinfo
make install
if [ $? == 0 ]; then
    cp -rf $prj_path/php-config/* $PHP_CONFIG_PATH/
    run_cmd "`sed -i "s/{{PHP_FPM_USER}}/$PHP_FPM_USER/" $PHP_CONFIG_PATH/php-fpm.d/www.conf`" 
    run_cmd "`sed -i "s/{{PHP_FPM_USER_GROUP}}/$PHP_FPM_USER/" $PHP_CONFIG_PATH/php-fpm.d/www.conf`" 
    run_cmd "`sed -i "s/{{PHP_FASTCGI_LISTEN_PORT}}/$PHP_FASTCGI_LISTEN_PORT/" $PHP_CONFIG_PATH/php-fpm.d/www.conf`" 
    run_cmd "ln -s $PHP_PATH/bin/* /usr/local/bin/"
    run_cmd "ln -s $PHP_PATH/sbin/* /usr/local/bin/"
    echo -e php install success. `date` >> install.log
    # install composer
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    run_cmd "mv composer.phar /usr/local/bin/"
    echo -e php install success. `date` >> install.log
else
    echo -e php install fail. `date` >> install.log
fi
