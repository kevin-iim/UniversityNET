#!/bin/bash -e
Eth=()
Vth=()
Account=()
Password=()
count=0
routerip=
filepath=
###########################################################################################
#检测设置是否出现错误
if [ ${#Account{*}} -ne ${#Vth[*]} -o ${#Vth[*]} -ne ${#Account{*}} -o ${#Account{*}} -ne ${#Password{*}} ]
then
{
    echo "check not pass"
    exit
}
else
{
    Quantity=${#Account{*}}
    #检测日志文件是否正常
    echo -e "\n" >> ${filepath}/WanError.log
    echo -e "\n" >> ${filepath}/LanError.log
    echo -e "\n" >> ${filepath}/dropping.log
    until [ `sed -n '$=' ${filepath}/dropping.log` -eq $Quantity ]
    do
    {
        if [ `sed -n '$=' ${filepath}/dropping.log` -lt $Quantity ]
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

    #创建虚拟网卡
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
    ping -I ${Vth[${count}]} -c 1 172.16.30.33
    if [ $? -eq 1 ];
    then
    {
        #telecom
        ping -I ${Vth[${count}]} -c 1 183.6.147.29
        if [ $? -eq 1 ];
        then
        {
            BTP=$(date)
            drop[${count}]=`expr ${drop[${count}]} + 1`
            sed -i "`expr ${count} + 1`c${drop[${count}]} ${BTP}" ${filepath}/dropping.log
            sed -i "25c${drop[*]}" ${filepath}/dropping.log
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
                fi
            }
            fi
        }
        else
        {
            #dhcp bug
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
    else
    {
        #unicom
        ping -I ${Vth[${count}]} -c 1 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            BTP=$(date)
            drop[${count}]=`expr ${drop[${count}]} + 1`
            #tag
            sed -i "`expr ${count} + 1`c${drop[${count}]} ${BTP}" ${filepath}/dropping.log
            sed -i "`expr $Quantity + 1`c${drop[*]}" ${filepath}/dropping.log
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
                fi
            }
            fi
        }
        fi
    }
    fi

    count=`expr ${count} + 1`
    if [ "${count}" -eq $Quantity ];
    then
    {
        count=0
    }
    fi

    done
}