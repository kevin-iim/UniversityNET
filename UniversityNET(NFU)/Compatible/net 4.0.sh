#!/bin/bash -e
Eth=()#物理网卡
Vth=()#VLAN
Account=()#账号
Password=()#密码
count=0
#每行账号密码网卡需要顺序一致
logpath=/mnt/log
###########################################################################################
#检测设置是否出现错误
if [ ${#Account[*]} -ne ${#Vth[*]} -o ${#Vth[*]} -ne ${#Account[*]} -o ${#Account[*]} -ne ${#Password[*]} ]
then
{
    echo "check not pass"
    exit
}
elif [ ${#Eth[*]} -eq ${#Vth[*]} ]
then
{
    Quantity=${#Account[*]}
    #创建虚拟网卡||创建等待列表
    until [ ! ${count} -lt $Quantity ]
    do
    {
        ip link add link ${Eth[${count}]} name ${Vth[${count}]} type macvlan
        ifconfig ${Vth[${count}]} up
        count=`expr ${count} + 1`
    }
    done
}
fi

telecom()
{
    ping -I ${Vth[${count}]} -c 3 10000.gd.cn
    if [ $? -eq 1 ];
    then
    {
        ping -I ${Vth[${count}]} -c 2 202.96.128.166
        if [ $? -eq 0 ];
        then
        {
            CTP=$(date +%s000)
            curl --interface ${Vth[${count}]} -s -d "userid=${Account[${count}]}@NFSYSU.GZ&passwd=${Password[${count}]}&wlanuserip=${userip}&wlanacname=nfsysugz2&auth_type=PAP&wlanacIp=183.6.109.10" --user-agent "Supplicant" "http://219.136.125.139/portalAuthAction.do"
        }
        else
        {
            ifconfig ${Vth[${count}]} down
            ifconfig ${Vth[${count}]} up
        }
        fi
    }
    fi
}

unicom()
{
    ping -I ${Vth[${count}]} -c 3 unicom.2333.ink
    if [ $? -eq 1 ];
    then
    {
        ping -I ${Vth[${count}]} -c 2 172.16.30.33
        if [ $? -eq 0 ];
        then
        {
            CTP=$(date +%s000)
            curl --interface ${Vth[${count}]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[${count}]}&upass=${Password[${count}]}&0MKKey=123456&R1=0&R3=1&R6=0&para=00&v6ip=&_=${CTP}"
        }
        else
        {
            ifconfig ${Vth[${count}]} down
            ifconfig ${Vth[${count}]} up
        }
        fi
    }
    fi
}

count=0
{
    while true
    do
    userip=$(ifconfig ${Vth[${count}]}|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:")
    if [[ $userip =~ "10.12." ]]
    then
    {
        telecom
    }
    elif [[ $userip =~ "10.51." ]];
    then
    {
        unicom
    }
    else
    {
        #dhcp bug
        ifconfig ${Vth[${count}]} down
        ifconfig ${Vth[${count}]} up
    }
    fi

    count=`expr ${count} + 1`
    if [ "${count}" -eq $Quantity ];
    then
    {
        count=0
    }
    fi

    until [ $(uptime |tr -d ",.:qwertyuiopasdfghjklzxcvbnm"|awk '{print $3}') -lt `expr $(grep -c ^processor /proc/cpuinfo) \* 100` ]
    do
    {
        sleep 1s
    }
    done

    done
}