# Jenkins

> 阿里云上Jenkins相关文档,基于阿里云和docker构建的Django项目自动化运维产品线.

#### 安装启动jenkins

- 通过以下小脚本利用docker安装并启动jenkins,脚本详细内容点击观看

  [jenkins.sh](https://github.com/erdongmuxin/Jenkins/blob/master/jenkins.sh)
  
- 输入ip:port登录,在如下地方输入脚本给出的密码

  ![密码输入](https://erdongmuxin.oss-cn-shenzhen.aliyuncs.com/小书匠/1558421090244.png)

- 选择插件,创建管理员用户即可愉快的使用了

#### 创建一个Django项目以便测试(非必须操作,知识为了以后方便)

- 首先我们利用docker安装一个Django项目

  ```bash
  # 下载镜像
  docker pull guiaiy/django
  
  # 下载配置
  docker run -d --name django guiaiy/django
  docker cp django:/etc/nginx ./
  docker stop django
  docker rm django
  
  # 启动容器
  name=django
  file_path=/home/django
  port=80
  mv ./nginx ${file_path}/
  docker run -d --name ${name} -p ${port}:80 -v ${file_path}/code/app:/home/docker/code/app -v ${file_path}/nginx:/etc/nginx guiaiy/django
  
  # 具体配置请参考容器内部/home/docker/code/README.txt,需要和开发沟通配置
  ```

#### 创建流水线

- 进入jenkins,在jenkins创建一个流水线,用来监控代码,每当master分支有合并的时候,自动将代码推送到服务器

  1. 打开blueocean

     ![](https://erdongmuxin.oss-cn-shenzhen.aliyuncs.com/小书匠/1558429721786.png)

  2. 创建流水线

     ![](D:\Images\jenkins\创建流水线.png)

  3. 接下来创建第一个节点,保存,然后去构建

     ![](https://erdongmuxin.oss-cn-shenzhen.aliyuncs.com/小书匠/1558429757941.png)

     ![](https://erdongmuxin.oss-cn-shenzhen.aliyuncs.com/小书匠/1558429752622.png)

  4. 去机器上验证一下,看看是否有这样的文件

     ![](https://erdongmuxin.oss-cn-shenzhen.aliyuncs.com/小书匠/1558429761895.png)

- 至此,一个简单的流水线已经创建完成

  > 当然不用blueocean也是很好的,直接新建任务,创建一个流水线任务即可,使用blueocean主要是节约一些编写Jenkinsfile的时间

#### 监控master分支,自动推送项目

- 和普通的流水线不同的是,blueocean多分支的流水线触发器不需要在jenkins中创建,只需要在gitlab中,增加webhook,然后以下面的格式添加即可

  ```
  http://my-jenkins-host/git/notifyCommit?url=git@gitlab.example.com:group/repository.git&delay=0sec
  
  # my-jenkins-host填写jenkins的ip和port
  # git@gitlab.example.com:group/repository.git填写git的路径
  ```
- 下面让我们在项目里面添加一个readme.txt,然后提交到master,jenkins会自动给你完成一次创建

  ![](https://erdongmuxin.oss-cn-shenzhen.aliyuncs.com/小书匠/1558429769379.png)

  - 注意到我有一次失败的构建,是因为在shell里面echo > /root/1.txt,而jenkins是没有权限的,注意一切构建都是以"workspace/项目_分支/"为根目录的
  
- 接下来,我们写一个简单的脚本,来部署Django项目 

  1. 我们先不改动piplines,直接合并Django项目,然后看一眼workspace

     ![](D:\Images\jenkins\workspace.png)

     - 可以看到的是,他不仅仅给你自动创建了一个Jenkinsfile的文件,并且把你git上的所有内容都拉取下来了
   - 但是因为是多分支的流水线,所以需要额外注意,因为不同的分支,可能执行不同的操作,如果用同样的名字,会导致,其他分区在合并到master的时候,会覆盖掉master的Jenkinsfile文件,所以使用blueocean的时候,如果有不同分支的需求,有两种(或以上)解决方案
      2. 在Jenkinsfile里面加上判断条件
      2. 创建多个单分支的流水线,协同操作
  

