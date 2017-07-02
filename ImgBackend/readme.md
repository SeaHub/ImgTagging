# 后台部署指南

## 定义
  为了方便描述，定义后台目录为根目录 即"/"

## 部署PHP业务后台

安装依赖：
```shell
$ composer update
```

复制配置文件
```shell
$ cp ./.env.example ./.env
```

然后填写.env配置文件，根据实际情况填写数据库连接，以及APP_KEY,JWT_SECRET(随机生成32位密钥英文+数字)

```shell
$ chmod -R 777 ./bootstrap/
$ chmod -R 777 ./storage/
$ chmod -R 777 ./public/cifar/
$ chmod -R 777 ./public/swagger-ui/
```

若想查看后台接口，可以利用swagger生成业务接口文档
假设项目部署在本地，端口号为8080
访问 http://localhost:8080/api/v1/generateDoc 来自动生成业务接口文档
访问 http://localhost:8080/swagger-ui 来查看业务接口文档

