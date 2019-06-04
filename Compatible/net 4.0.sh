#!/bin/bash -e
Eth=()
Vth=()
Account=()
Password=()
count=0
logpath=/mnt/log
###########################################################################################
#检测设置是否出现错误
if [ ${#Account[*]} -ne ${#Vth[*]} -o ${#Vth[*]} -ne ${#Account[*]} -o ${#Account[*]} -ne ${#Password[*]} ]
then
{
    echo "check not pass"
    exit
}
else
{
    Quantity=${#Account[*]}
    #创建虚拟网卡||创建drop wan lan school组||创建等待列表
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
count=0
{
    while true
    do
    userip=$(ifconfig ${Vth[${count}]}|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:")
    if [[ $userip =~ "10.12." ]]
    then
    {
        #telecom
    }
    elif [[ $userip =~ "10.51." ]];
    then
    {
        #unicom
        ping -I ${Vth[${count}]} -c 1 unicom.2333.ink
        if [ $? -eq 1 ];
        then
        {
            drop[${count}]=`expr ${drop[${count}]} + 1`
            sed -i "`expr $(date +%H) + 1`c$(date +%H)hour ${drop[*]} $(date) $(uptime |tr -d ",:qwertyuiopasdfghjklzxcvbnm"|awk '{print $5}')"  ${logpath}/Dropping.log
            ping -I ${Vth[${count}]} -c 2 unicom.2333.ink
            if [ $? -eq 1 ];
            then
            {
                drop[${count}]=`expr ${drop[${count}]} + 2`
                sed -i "`expr $(date +%H) + 1`c$(date +%H)hour ${drop[*]} $(date) $(uptime |tr -d ",:qwertyuiopasdfghjklzxcvbnm"|awk '{print $5}')"  ${logpath}/Dropping.log
                ping -I ${Vth[${count}]} -c 1 210.21.79.129
                if [ $? -eq 1 ];
                then
                {
                    wan[${count}]=`expr ${wan[${count}]} + 1`
                    sed -i "`expr $(date +%H) + 1`c$(date +%H)hour ${wan[*]} $(date) $(uptime |tr -d ",:qwertyuiopasdfghjklzxcvbnm"|awk '{print $5}')"  ${logpath}/WanError.log
                    ping -I ${Vth[${count}]} -c 1 10.10.252.181
                    if [ $? -eq 1 ];
                    then
                    {
                        school[${count}]=`expr ${school[${count}]} + 1`
                        sed -i "`expr $(date +%H) + 1`c$(date +%H)hour ${school[*]} $(date) $(uptime |tr -d ",:qwertyuiopasdfghjklzxcvbnm"|awk '{print $5}')"  ${logpath}/SchoolError.log
                    }
                    fi
                    ping -I ${Vth[${count}]} -c 1 172.16.30.33
                    if [ $? -eq 0 ];
                    then
                    {
                        CTP=$(date +%s000)
                        curl --interface ${Vth[${count}]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[${count}]}&upass=${Password[${count}]}&0MKKey=123456&R1=0&R3=1&R6=0&para=00&v6ip=&_=${CTP}"
                    }
                    else
                    {
                        lan[${count}]=`expr ${lan[${count}]} + 1`
                        sed -i "`expr $(date +%H) + 1`c$(date +%H)hour ${lan[*]} $(date) $(uptime |tr -d ",:qwertyuiopasdfghjklzxcvbnm"|awk '{print $5}')"  ${logpath}/LanError.log
                        ifconfig ${Vth[${count}]} down
                        ifconfig ${Vth[${count}]} up
                    }
                    fi
                }
                fi
            }
            fi
        }
        fi
    }
    else
    {
        #dhcp bug
        lan[${count}]=`expr ${lan[${count}]} + 1`
        ifconfig ${Vth[${count}]} down
        ifconfig ${Vth[${count}]} up
    }
    fi

    if [ $(date +%M) == 00 ];
    then
    {
        drop[${Quantity}]=0
        count=0
        until [ ! ${count} -lt $Quantity ]
        do
        {
            drop[${count}]=0
            wan[${count}]=0
            school[${count}]=0
            lan[${count}]=0
            count=`expr ${count} + 1`
        }
        done
        count=0
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