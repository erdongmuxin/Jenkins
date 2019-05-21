#!/bin/bash
# 安装docker,已经安装则跳过这一步
rpm -q docker || yum -y install docker

# docker的日志文件有时候会很大,而阿里云初始磁盘往往只有40G,但是可以通过以下操作更改磁盘,例如,已经将一个100G的硬盘挂在到了/opt

# cd /var/lib
# mv docker/* /opt/docker/
# rm -rf docker
# ln -s /opt/docker/ /var/lib/docker

# 启动docker,并设置开机自启
systemctl start docker
systemctl enable docker

# 下载镜像,此镜像是整合了BlueOcean和初始推荐插件的镜像
echo '如果下载速度特别慢,请用ctrl + c中断,然后重新运行降本'
docker pull guiaiy/jenkins

# 确认镜像下载成功
while [[ $? -ne 0 ]];
do
	docker pull guiaiy/jenkins
done

# 这里只用挂载目录做了自定义配置,如果需要自定义例如端口的其他配置,请自行修改
echo '"""
请输入jenkins的家目录,默认目录/home/jenkins
"""
'
read path
file_path=${path:-/home/jenkins}
[[ -f ${file_path} ]] || mkdir -p ${file_path}

# Jenkins可能需要有对挂在目录的操作权限
id jenkins || useradd jenkins
chown -R jenkins:jenkins ${file_path}

# 启动Jenkins镜像
docker run -d --restart always --name jenkins -p 8080:8080 -p 50000:50000 -v ${file_path}:/var/jenkins_home guiaiy/jenkins

# 等待Jenkins启动一小会
sleep 10

# 获取初始密码
echo '"""
初始密码如下
""""
'
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
# cat ${file_path}/secrets/initialAdminPassword 因为无法判断用户是否在path后面输入'/',所以建议用上面的方法获取初始密码
