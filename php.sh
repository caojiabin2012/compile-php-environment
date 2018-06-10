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
    yum install -y m4 autoconf libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel

elif which apt-get >/dev/null; then
    apt-get install -y m4 autoconf libxml2 libxml2-dev binutils autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev libc-ares-dev libjemalloc-dev libcurl4-openssl-dev bzip2 libbz2-dev curl libjpeg-dev libpng-dev libpng12-dev  libfreetype6-dev libgmp-dev libmcrypt-dev libreadline6-dev libxslt1-dev
 
elif which brew >/dev/null; then
    echo "Darwin"
fi

ensure_user "$PHP_FPM_USER"
ensure_dir "$package/php"
remove_dir "$package/php/*"
if [ ! -f "$package/php-$PHP_VERION.tar.bz2" ]; then
    wget -O $package/php-$PHP_VERSION.tar.bz2 $PHP_DOWNLOAD_URL 
fi

tar -jxvf $package/php-$PHP_VERSION.tar.bz2 -C $package/php/ --strip-components 1
cd $package/php 
./configure --prefix=$PHP_PATH --with-config-file-path=$PHP_CONFIG_PATH --enable-fpm --enable-inline-optimization --disable-debug --disable-rpath --enable-shared --enable-soap --with-libxml-dir --with-xmlrpc --with-openssl --with-mcrypt --with-mhash --with-pcre-regex --with-sqlite3 --with-zlib --enable-bcmath --with-iconv --with-bz2 --enable-calendar --with-curl --with-cdb --enable-dom --enable-exif --enable-fileinfo --enable-filter --with-pcre-dir --enable-ftp --with-gd --with-openssl-dir --with-jpeg-dir --with-png-dir --with-zlib-dir --with-freetype-dir --enable-gd-native-ttf --enable-gd-jis-conv --with-gettext --with-gmp --with-mhash --enable-json --enable-mbstring --enable-mbregex --enable-mbregex-backtrack --with-libmbfl --with-onig --enable-pdo --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-zlib-dir --with-pdo-sqlite --with-readline --enable-session --enable-shmop --enable-simplexml --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --with-libxml-dir --with-xsl --enable-zip --enable-mysqlnd-compression-support --with-pear --enable-opcache
make install
if [ $? == 0 ]; then
    cp -rf $prj_path/php-config/* $PHP_CONFIG_PATH/
    run_cmd "`sed -i "s/{{PHP_FPM_USER}}/$PHP_FPM_USER/g" $PHP_CONFIG_PATH/php-fpm.d/www.conf`" 
    run_cmd "`sed -i "s/{{PHP_FPM_USER_GROUP}}/$PHP_FPM_USER/g" $PHP_CONFIG_PATH/php-fpm.d/www.conf`" 
    run_cmd "`sed -i "s/{{PHP_FASTCGI_LISTEN_PORT}}/$PHP_FASTCGI_LISTEN_PORT/g" $PHP_CONFIG_PATH/php-fpm.d/www.conf`" 
    run_cmd "ln -s $PHP_PATH/bin/* /usr/local/bin/"
    run_cmd "ln -s $PHP_PATH/sbin/* /usr/local/bin/"
    echo -e php install success. `date` >> install.log

    # install composer
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    run_cmd "mv composer.phar /usr/local/bin/composer"
    echo -e php install success. `date` >> install.log
else
    echo -e php install fail. `date` >> install.log
fi
