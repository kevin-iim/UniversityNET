#!/bin/bash -e
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
    #检测日志文件是否正常
    echo -e "\n" >> ${logpath}/WanError.log
    echo -e "\n" >> ${logpath}/LanError.log
    echo -e "\n" >> ${logpath}/dropping.log
    until [ `sed -n '$=' ${logpath}/dropping.log` -eq 25 ]
    do
    {
        if [ `sed -n '$=' ${logpath}/dropping.log` -lt 25 ]
        then
        {
            echo -e "\n" >> ${logpath}/dropping.log
        }
        else
        {
            sed -i '$d' ${logpath}/dropping.log
        }
        fi
    }
    done

    #创建虚拟网卡||创建drop组||创建等待列表
    until [ ! ${count} -lt $Quantity ]
    do
    {
        drop[${count}]=0
        droplist[${count}]=wired
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
    if [[ $userip =~ "10.12." || $userip =~ "10.13." ]]
    then
    {
        #telecom
        ping -I ${Vth[${count}]} -c 1 183.6.147.29
        if [ $? -eq 1 ];
        then
        {
            BTP=$(date)
            drop[${count}]=`expr ${drop[${count}]} + 1`
            ping -I ${Vth[${count}]} -c 2 183.6.147.29
            if [ $? -eq 1 ];
            then
            {
                ping -I ${Vth[${count}]} -c 1 202.96.128.166
                if [ $? -eq 0 ];
                then
                {
                    curl --interface ${Vth[${count}]} -s -d "userid=${Account[${count}]}@NFSYSU.GZ&passwd=${Password[${count}]}&wlanuserip=${userip}&wlanacname=nfsysugz2&auth_type=PAP&wlanacIp=183.6.109.10" --user-agent "Supplicant" "http://219.136.125.139/portalAuthAction.do"
                    if [ `sed -n '$=' ${logpath}/WanError.log` 100 ]
                    then
                    {
                        sed -i '$d' ${logpath}/WanError.log
                    }
                    fi
                    BTP=$(date)
                    sed -i "1i${BTP} ${Account[${count}]} ${Vth[${count}]}" ${logpath}/WanError.log
                }
                fi
            }
            fi
        }
        fi
    }
    elif [[ $userip =~ "10.51." ]];
    then
    {
        #unicom wired
        ping -I ${Vth[${count}]} -c 1 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            BTP=$(date)
            drop[${count}]=`expr ${drop[${count}]} + 1`
            ping -I ${Vth[${count}]} -c 2 221.5.88.88
            if [ $? -eq 1 ];
            then
            {
                CTP=$(date +%s000)
                curl --interface ${Vth[${count}]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[${count}]}&upass=${Password[${count}]}&0MKKey=123456&R1=0&R3=1&R6=0&para=00&v6ip=&_=${CTP}"
                if [ `sed -n '$=' ${logpath}/WanError.log` -eq 100 ]
                then
                {
                    sed -i '$d' ${logpath}/WanError.log
                }
                fi
                BTP=$(date)
                sed -i "1i${BTP} ${Account[${count}]} ${Vth[${count}]}" ${logpath}/WanError.log
            }
            fi
        }
        fi
    }
    elif [[ $userip =~ "10.52." || $userip =~ "10.53." ]];
    then
    {
        #unicom wireless
        if [ ${droplist[$count]} == wired ];
        then
        {
            droplist[$count]=fine
            ping -I ${Vth[${count}]} -c 3 221.5.88.88
            if [ $? -eq 1 ];
            then
            {
                CTP=$(date +%s000)
                curl --interface ${Vth[${count}]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[${count}]}&upass=${Password[${count}]}&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
            }
            fi
        }
        elif [ ${droplist[$count]} == fine ];
        then
        {
            ping -I ${Vth[${count}]} -c 1 221.5.88.88
            if [ $? -eq 1 ];
            then
            {
                BTP=$(date)
                drop[${count}]=`expr ${drop[${count}]} + 1`
                ping -I ${Vth[${count}]} -c 2 221.5.88.88
                if [ $? -eq 1 ];
                then
                {
                    droplist[$count]=`expr $(date +%M) - 1`
                    if [ ${droplist[$count]} -eq -1 ]
                    then
                    {
                        droplist[$count]=59
                    }
                    fi
                    CTP=$(date +%s000)
                    curl --interface ${Vth[${count}]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[${count}]}&upass=${Password[${count}]}&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
                    if [ `sed -n '$=' ${logpath}/WanError.log` -eq 100 ]
                    then
                    {
                        sed -i '$d' ${logpath}/WanError.log
                    }
                    fi
                    BTP=$(date)
                    sed -i "1i${BTP} ${Account[${count}]} ${Vth[${count}]}" ${logpath}/WanError.log
                }
                fi
            }
            fi
        }
        elif [ ${droplist[$count]} == $(date +%M) ]
        then
        {
            ping -I ${Vth[${count}]} -c 1 221.5.88.88
            if [ $? -eq 1 ];
            then
            {
                BTP=$(date)
                drop[${count}]=`expr ${drop[${count}]} + 1`
                ping -I ${Vth[${count}]} -c 2 221.5.88.88
                if [ $? -eq 1 ];
                then
                {
                    CTP=$(date +%s000)
                    curl --interface ${Vth[${count}]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[${count}]}&upass=${Password[${count}]}&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
                    droplist[$count]=fine
                }
                fi
            }
            fi
        }
        else
        {
            sed -i "1c$(date) ${droplist[*]}" ${logpath}/dropping.log
        }
        fi
    }
    else
    {
        #dhcp bug
        ifconfig ${Vth[${count}]} down
        ifconfig ${Vth[${count}]} up
        if [ `sed -n '$=' ${logpath}/LanError.log` -eq 100 ]
        then
        {
            sed -i '$d' ${logpath}/LanError.log
        }
        fi
        BTP=$(date)
        sed -i "1i${BTP} ${Account[${count}]} ${Vth[${count}]}" ${logpath}/LanError.log
    }
    fi

    count=`expr ${count} + 1`
    if [ "${count}" -eq $Quantity ];
    then
    {
        count=0
    }
    fi

    if [ $(date +%M) == 00 ];
    then
    {
        count=0
        until [ ! ${count} -lt $Quantity ]
        do
        {
            drop[${count}]=0
            count=`expr ${count} + 1`
        }
        done
        count=0
    }
    else
    {
        sed -i "`expr $(date +%H) + 2`c$(date +%H) ${drop[*]}" ${logpath}/dropping.log
    }
    fi

    until [ $(uptime |tr -d "up"|tr -d ",.:qwertyuiopasdfghjklzxcvbnm"|awk '{print $3}') -lt `expr $(grep -c ^processor /proc/cpuinfo) \* 100` ]
    do
    {
        sleep 1s
    }
    done

    done
}&