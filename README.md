# CompilePHPEnvironment

# 源码编译php开发环境
* git clone 获取代码
* 命令行执行：bash init.sh
* 浏览器：本机ip/index.php

# 目录分析
```
├── ext                         PHP扩展
│   ├── mongodb.sh
│   ├── redis.sh
│   ├── swoole.sh
│   └── yaf.sh
├── libs                        第三方类库
    └── base.sh
├── nginx-config                nginx配置文件
│   ├── conf
│   │   └── nginx.conf
│   └── vhosts
│       └── admin.jiabin.cn.conf
├── php-config                  php配置文件
│   ├── php-fpm.conf
│   ├── php-fpm.d
│   │   └── www.conf
│   └── php.ini
└── tools                       常用的工具方法
├── config.sh                   配置文件
├── init.sh                     初始化脚本
├── install.log                 log
├── nginx.sh                    nginx安装脚本
├── php.sh                      php安装脚本
├── README.md
```

# 用到的第三方类库版权归对应作者或组织，本人写的没有任何版权，欢迎使用！
