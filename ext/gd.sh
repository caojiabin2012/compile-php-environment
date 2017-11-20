#!bin/bash
set -e

if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
source $prj_path/tools/base.sh

package=$prj_path/package

# jpeg
ensure_dir "$package/jpegsrc"
remove_dir "$package/jpegsrc/*"
if [ ! -f "$package/jpegsrc.tar.gz" ]; then
    wget -O $package/jpegsrc.tar.gz http://www.ijg.org/files/jpegsrc.v9b.tar.gz
fi
tar -zxvf $package/jpegsrc.tar.gz -C $package/jpegsrc/ --strip-components 1
cd $package/jpegsrc
./configure --prefix=/usr/local/jpeg
make && make install
cd $package/php/ext/gd
if [ -f "$PHP_PATH/bin/phpize" ]; then
    $PHP_PATH/bin/phpize
    ./configure --with-php-config=$PHP_PATH/bin/php-config --with-gd --with-jpeg-dir=/usr/local/jpeg
else
    phpize
    ./configure --with-gd --with-jpeg-dir=/usr/local/jpeg
fi
make install
if [ $? == 0 ]; then
    run_cmd "`echo -e extension=gd.so >> $PHP_CONFIG_PATH/php.ini`"
    echo -e yac install success. `date` >> $prj_path/install.log
else
    echo -e yac install fail. `date` >> $prj_path/install.log
fi
