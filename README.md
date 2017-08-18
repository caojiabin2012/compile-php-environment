# 源码编译定制您的PHP运行环境，开发环境和生产环境均可！

# 能做什么
* 一键编译PHP开发环境，包含了一些常用扩展如：redis、yaf、mongodb、swoole。
* 可扩展行很强，相信您都懂linux哪怕是一点也好，再参考下已经写好的shell脚本，复制一个稍微改改，便可以使用，将节省下的时间去撩妹。

# 目录分析
```
├── ext                         PHP扩展
│   ├── mongodb.sh
│   ├── redis.sh
│   ├── swoole.sh
│   └── yaf.sh
├── libs                        第三方类库
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
    └── base.sh
    ├── config.sh               配置文件
    ├── init.sh                 初始化脚本
    ├── install.log             log
    ├── nginx.sh                nginx安装脚本
    ├── php.sh                  php安装脚本
    ├── README.md
```

# 流程分析
* config.sh配置相应的信息：比如nginx监听端口、php-fpm监听端口等
* 安装的程序会读取相应的配置，每个shell脚本(nginx.sh、php.sh、和ext目录下的shell)都可以单独安装，也可以通过init.sh串联起来整套安装。

# 使用方法
* git clone https://github.com/caojiabin2012/CompilePHPEnvironment.git
* cd CompilePHPEnvironment
* bash init.sh
* 执行浏览器：本机ip/index.php

# 安装失败需要怎么处理
* 作者已经很努力的调试CentOS和Ubuntu了，将缺少的类库都写到了程序中。在使用中如果您发现还是有遗漏的类库，如果能解决欢迎提交代码，如果不能，欢迎来此提交issue：https://github.com/caojiabin2012/CompilePHPEnvironment/issues/new
* 提交的issue一定要写好系统名称和版本哦！

# 为何会开发此脚本
* 每次搭建环境都要花费点时间，不论是源码编译还是使用源安装(yum或apt)。
* 编译安装相比源优点是可以定制版本，但是需要自己安装依赖库，速度慢，其实各有优缺点。
* 将自己经常重复的工作，写成一个项目开源出来，帮助自己还能帮助他人，何乐不为。

# 为什么没见到mysql安装脚本呢
* 因为生产环境基本不会在本机搭建mysql，平时开发时大家基本都是用测试环境数据库，本地的mysql并不是很重要，以后可能考虑加上。

# 项目名称由来XxOoEnvironment
* CompilePHPEnvironment     编译版本
* DockerPHPEnvironment      Docker版本(下一个开源项目)
* CompilePythonEnvironment 
* DockerPythonEnvironment
* CompileGoEnvironment 
* DockeGoEnvironment
* ... 喜欢分享的你可以一起参与进来，90后的我们一起追赶80后吧！

# 开源协议
* 第三方类库版权参照对应作者或组织
* 本人写的没有任何版权欢迎使用
