#!/usr/bin/env bash
#
#autor:zeng
#date:

#创建用户
groupadd mysql
useradd -M -g mysql -s /sbin/nologin mysql
#安装依赖
rpm -qa | grep mariadb-libs
if [ $? -eq 0 ];then
rpm -e --nodeps mariadb-libs
else
yum -y install gcc gcc-c++  ncurses ncurses-devel bison libgcrypt perl make cmake &>/dev/null
  if [ $? -eq 0 ];then
    yum -y groupinstall "Development Tools" &>/dev/null
  fi
fi
#解压mysql数据包
if [ -f /usr/local/ ];then
tar xf mysql-complete-5.7.25.tar.xz -C /usr/local/
else
mkdir -p /usr/local/mysqld/

tar xf mysql-complete-5.7.25.tar.xz -C /usr/local/

chown -R mysql:mysql /usr/local/mysqld/*
fi

#添加环境变量

echo "export PATH=$PATH:/usr/local/mysqld/mysql/bin" >>/etc/profile

source /etc/profile

chown -R mysql:mysql /usr/local/mysqld/*

#配置MySQL配置文件

mv  /etc/{my.cnf,my.cnf.bak}

cp file  /etc/my.cnf

ln -s /usr/local/mysqld/tmp/mysql.sock /tmp/mysql.sock

cp  /usr/local/mysqld/mysql/support-files/mysql.server /etc/init.d/mysqld

#mysql开机自启

chkconfig --add mysqld

chkconfig mysqld on

#清空MySQL的uuid

> /usr/local/mysqld/data/auto.cnf

#修改server_id

ip=$(ip a | awk -F" " 'NR==9 { print $2 }' | cut -c 10-12)
sed -ri s/server_id=11/server_id=$ip/g /etc/my.cnf

#软连接快速启动 

ln -s /usr/local/mysqld/mysql/support-files/mysql.server /usr/bin/mysql.server

mysql.server restart &>/dev/null

if [ $? -eq 0 ];then
echo  "安装成功！！！"
fi






