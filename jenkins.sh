#!/bin/bash
rpm -q docker || yum -y install docker
systemctl start docker
systemctl enable docker
docker pull guiaiy/jenkins
while [ $? -ne 0 ];
do
	docker pull guiaiy/jenkins
done
echo '"""
请输入jenkins的家目录,默认目录/home/jenkins
"""
'
read path
file_path=${path:-/home/jenkins}
mkdir -p $file_path
chown -R jenkins:jenkins $file_path
docker run -d --restart always --name jenkins -p 8080:8080 -p 50000:50000 -v $file_path:/var/jenkins_home guiaiy/jenkins
sleep 5

echo '"""
初始密码如下
""""
'
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
# cat ${file_path}/secrets/initialAdminPassword 因为无法判断用户是否在path后面输入'/',所以建议用上面的方法获取初始密码
