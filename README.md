# Jenkins
> 阿里云上Jenkins相关文档,基于阿里云和docker构建的Django项目自动化运维产品线.

#### 安装启动jenkins

- 通过以下小脚本利用docker安装并启动jenkins,脚本详细内容点击观看

  [jenkins.sh](https://github.com/erdongmuxin/Jenkins/blob/master/jenkins.sh)
  
- 输入ip:port登录,在如下地方输入脚本给出的密码

  ![密码输入](https://erdongmuxin.oss-cn-shenzhen.aliyuncs.com/小书匠/1558421090244.png)

- 选择插件,创建管理员用户即可愉快的使用了

#### 创建一个Django项目以便测试

- 首先我们利用docker安装一个Django项目

  ```bash
  # 下载镜像
  docker pull guiaiy/django-uwsgi-nginx
  
  # 启动容器
  name=django
  file_path=/home/sd/python/dashun/app
  port=80
  docker run -d --name ${name} -p ${port}:80 -v ${file_path}:/home/docker/code/app django
  
  # 具体配置请参考容器内部/home/docker/code/README.txt,需要和开发沟通配置
  ```

- 然后将我们在jenkins创建一个多分支流水线,用来监控代码,每当master分支有合并的时候,自动将代码推送到服务器

  ![创建流水线](D:\Images\jenkins\创建流水线.png)

  