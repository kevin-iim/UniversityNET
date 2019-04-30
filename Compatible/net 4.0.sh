#!/bin/bash -e
Eth=()
Vth=()
Account=()
Password=()
count=0
routerip=10.192.168.225
filepath=/mnt/bash
###########################################################################################
#检测设置是否出现错误
quantity[0]=${#Eth[*]}
quantity[1]=${#Vth[*]}
quantity[2]=${#Account{*}}
quantity[3]=${#Password{*}}
if [ ${quantity[0]} -ne ${quantity[1]} -o ${quantity[1]} -ne ${quantity[2]} -o ${quantity[2]} -ne ${quantity[3]} ]
then
{
    echo "check not pass"
    exit
}
else
{
    echo "check pass"
}
fi
###########################################################################################
#检测日志文件是否正常
echo -e "\n" >> ${filepath}/WanError.log
echo -e "\n" >> ${filepath}/LanError.log
echo -e "\n" >> ${filepath}/dropping.log
until [ `sed -n '$=' ${filepath}/dropping.log` -eq ${quantity[1]} ]
do
{
    if [ `sed -n '$=' ${filepath}/dropping.log` -lt ${quantity[1]} ]
    then
    {
        echo -e "\n" >> ${filepath}/dropping.log
    }
    else
    {
        sed -i '$d' ${filepath}/dropping.log
    }
    fi
}
done
###########################################################################################
#创建虚拟网卡
until [ ! ${count} -lt `expr ${count} + 1` ]
do
{
    ip link add link ${Eth[${count}]} name ${Vth[${count}]} type macvlan
    ifconfig ${Vth[${count}]} up
    count=`expr ${count} + 1`
}
done