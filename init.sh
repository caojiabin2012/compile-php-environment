#!bin/bash
set -e

echo -e "*****************************************" > install.log
echo -e "*   Author:caojiabin2012@gmail.com      *" >> install.log
echo -e "*****************************************" >> install.log
prj_path=$(cd $(dirname $0); pwd -P)

bash nginx.sh
bash php.sh
bash ext/redis.sh
bash ext/mongodb.sh
bash ext/yaf.sh
bash ext/swoole.sh
