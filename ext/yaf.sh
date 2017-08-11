#!bin/bash
if  [ ! -n "$prj_path" ] ;then
    prj_path=$(cd ../$(dirname $0); pwd -P)
fi
source $prj_path/config.sh
package=$prj_path/package

if [ ! -d "$package/yaf" ]; then
    mkdir -p $package/yaf
fi
rm -rf $package/yaf/*
wget -O $package/yaf.tgz ${url} 

tar -zxvf $package/yaf.tgz -C $package/yaf/ --strip-components 1
cd $package/yaf 
$PHP_PATH/bin/phpize
./configure --with-php-config=$PHP_PATH/bin/php-config
#make test | echo y  
make install 
if [ $? == 0 ]; then
    echo -e yaf install success. `date` >> install.log
else
    echo -e yaf install fail. `date` >> install.log
fi
