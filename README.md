# Jenkins
> 阿里云上Jenkins相关文档,基于阿里云和docker构建的Django项目自动化运维产品线.

#### 安装启动jenkins

- 通过以下小脚本利用docker安装并启动jenkins,脚本详细内容点击观看

  [jenkins.sh](https://github.com/erdongmuxin/Jenkins/blob/master/jenkins.sh)
  
- 输入ip:port登录,在如下地方输入脚本给出的密码

  ![密码输入](https://erdongmuxin.oss-cn-shenzhen.aliyuncs.com/小书匠/1558421090244.png)

- 选择插件,创建管理员用户即可愉快的使用了

#### 创建一个Django项目以便测试

- Django项目同样通过docker创建,我同时为其编写了脚本

  