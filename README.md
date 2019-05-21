

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

  1. 打开blueocean

     ![](D:\Images\jenkins\打开blueocean.png)

  2. 创建流水线

     ![](D:\Images\jenkins\创建流水线.png)

  3. 接下来创建第一个节点,保存,然后去构建

     ![](D:\Images\jenkins\begining.png)

     ![](D:\Images\jenkins\成功第一次.png)

  4. 去机器上验证一下,看看是否有这样的文件

     ![](D:\Images\jenkins\验证.png)

- 至此,一个简单的流水线穿件已经完成

#### 监控master分支,自动推送项目

- 和单分支的流水线不同的是,多分支的流水线触发器不需要在jenkins中创建,只需要在gitlab中,增加webhook,然后以下面的格式添加

  ```
  http://my-jenkins-host/git/notifyCommit?url=git@gitlab.example.com:group/repository.git&delay=0sec
  
  # my-jenkins-host填写jenkins的ip和port
  # git@gitlab.example.com:group/repository.git填写git的路径
  ```

- 下面让我们在项目里面添加一个readme.txt,然后提交到master试试吧

  ![](D:\Images\jenkins\第二次成功的构建.png)

  - 注意到我又一次失败的构建,是因为在shell里面echo > /root/1.txt,而jenkins是没有权限的,注意一切构建都是以"workspace/项目_分支/"为根目录的







