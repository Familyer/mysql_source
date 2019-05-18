#!/bin/bash
#
#Autor:zeng
#Date:2019/4/12
#usage: add logged in user
if [ -f ./passwd ];then

 passwd=`cat passwd | awk 'NR==3 {print $3}'`
 path=`mysql -uroot -p"$passwd" -e "show variables like  '%secure%';" | awk 'NR==4 {print $2}' 2>/dev/null`
 mysql -uroot -p"$passwd" -e "use could_1901;select name from info into outfile'"$path"file.txt'" 2>/dev/null

else
  echo " 缺少 passwd 文件 执行失败！！"
  exit

fi

j=0
for i in $( cat "$path"file.txt )
do
 mysql -uroot -p"$passwd" -e " create user '$i'@$(ifconfig | awk 'NR==2 {print $2}') identified by '(Zeng..0412)'" 2>/dev/null
if [ $? -eq 0 ];then
let "j++"
fi
done
printf "共添加 $j 位用户！！"

rm -rf "$path"file.txt


