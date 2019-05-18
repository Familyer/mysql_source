#!/bin/bash
if [ -f /etc/my.cnf ];then
echo "skip-grant-tables=1">>/etc/my.cnf
else 
printf "未找到文件目录！"
fi

pkill mysql

ln -s /usr/local/mysqld/mysql/support-files/mysql.server /usr/bin/mysql.server

mysql.server restart &>/dev/null


mysql -uroot -e "use mysql; update user set authentication_string=password('(Zeng..0414)') where user='root';"
sed  -ri "s/skip-grant-tables=1//g" /etc/my.cnf
pkill mysql

mysql.server restart &>/dev/null

ip=`ifconfig | awk -F" " 'NR==2 { print $2 }' | awk -F'.' '{print $4}'`

mysql -uroot -p"(Zeng..0414)" -e "set global server_id=$ip;"

mysql.server restart &>/dev/null

if [ $? -eq 0 ];then
printf "修改成功！！"
fi






