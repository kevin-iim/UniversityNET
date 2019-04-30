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
###########################################################################################
#主程序
count=0

{
    while true
    do
    if [ ${count} -lt 3 ]
    then
    {
        #unicom
        ping -I ${Vth[${count}]} -c 1 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            BTP=$(date)
            drop[${count}]=`expr ${drop[${count}]} + 1`
            sed -i "`expr ${count} + 1`c${drop[${count}]} ${BTP}" ${filepath}/dropping.log
            sed -i "`expr ${count} + 2`c${drop[*]}" ${filepath}/dropping.log
            ping -I ${Vth[${count}]} -c 2 221.5.88.88
            if [ $? -eq 1 ];
            then
            {
                ping -I ${Vth[${count}]} -c 1 172.16.30.33
                if [ $? -eq 0 ];
                then
                {
                    CTP=$(date +%s000)
                    curl --interface ${Vth[${count}]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[${count}]}&upass=${Password[${count}]}&0MKKey=123456&R1=0&R3=1&R6=0&para=00&v6ip=&_=${CTP}"
                    if [ `sed -n '$=' ${filepath}/WanError.log` -eq 100 ]
                    then
                    {
                        sed -i '$d' ${filepath}/WanError.log
                    }
                    fi
                    BTP=$(date)
                    sed -i "1i${BTP} ${Account[${count}]} ${Vth[${count}]}" ${filepath}/WanError.log
                }
                else
                {
                    ifconfig ${Vth[${count}]} down
                    ifconfig ${Vth[${count}]} up
                    if [ `sed -n '$=' ${filepath}/LanError.log` -eq 100 ]
                    then
                    {
                        sed -i '$d' ${filepath}/LanError.log
                    }
                    fi
                    BTP=$(date)
                    sed -i "1i${BTP} ${Account[${count}]} ${Vth[${count}]}" ${filepath}/LanError.log
                }
                fi
            }
            fi
        }
        fi
    }
    else
    {
        #telecom
        ping -I ${Vth[${count}]} -c 1 183.6.147.29
        if [ $? -eq 1 ];
        then
        {
            BTP=$(date)
            drop[${count}]=`expr ${drop[${count}]} + 1`
            sed -i "`expr ${count} + 1`c${drop[${count}]} ${BTP}" ${filepath}/dropping.log
            sed -i "`expr ${count} + 2`c${drop[*]}" ${filepath}/dropping.log
            ping -I ${Vth[${count}]} -c 2 183.6.147.29
            if [ $? -eq 1 ];
            then
            {
                ping -I ${Vth[${count}]} -c 1 202.96.128.86
                if [ $? -eq 0 ];
                then
                {
                    userip=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|grep -v ${routerip}|grep -v 10.172.16.178|sed -n "`expr ${count} + 1`p")
                    curl --interface ${Vth[${count}]} -s -d "userid=${Account[${count}]}@NFSYSU.GZ&passwd=${Password[${count}]}&wlanuserip=${userip}&wlanacname=nfsysugz2&auth_type=PAP&wlanacIp=183.6.109.10" --user-agent "Supplicant" "http://219.136.125.139/portalAuthAction.do"
                    if [ `sed -n '$=' ${filepath}/WanError.log` 100 ]
                    then
                    {
                        sed -i '$d' ${filepath}/WanError.log
                    }
                    fi
                    BTP=$(date)
                    sed -i "1i${BTP} ${Account[${count}]} ${Vth[${count}]}" ${filepath}/WanError.log
                }
                else
                {
                    ifconfig ${Vth[${count}]} down
                    ifconfig ${Vth[${count}]} up
                    if [ `sed -n '$=' ${filepath}/LanError.log` -eq 100 ]
                    then
                    {
                        sed -i '$d' ${filepath}/LanError.log
                    }
                    fi
                    BTP=$(date)
                    sed -i "1i${BTP} ${Account[${count}]} ${Vth[${count}]}" ${filepath}/LanError.log
                }
                fi
            }
            fi
        }
        fi
    }
    fi

    count=`expr ${count} + 1`
    if [ "${count}" -eq 7 ];
    then
    {
        count=0
    }
    fi

    done
}