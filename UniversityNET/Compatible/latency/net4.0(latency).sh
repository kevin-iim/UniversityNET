#!/bin/bash -e
Vth=(wan wan1 wan2)
Account=(172011026 172011017 172011006)
Password=(QWEasd123 05252314 03294339)
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
    drop[${Quantity}]=0
    #检测日志文件是否正常
    echo -e "\n" >> ${logpath}/Dropping.log
    echo -e "\n" >> ${logpath}/WanError.log
    echo -e "\n" >> ${logpath}/SchoolError.log
    echo -e "\n" >> ${logpath}/LanError.log

    until [ `sed -n '$=' ${logpath}/Dropping.log` -eq 24 -a `sed -n '$=' ${logpath}/WanError.log` -eq 24 -a `sed -n '$=' ${logpath}/SchoolError.log` -eq 24 -a `sed -n '$=' ${logpath}/LanError.log` -eq 24 ]
    do
    {
        if [ `sed -n '$=' ${logpath}/Dropping.log` -lt 24 ]
        then
        {
            echo -e "\n" >> ${logpath}/Dropping.log
        }
        elif [ `sed -n '$=' ${logpath}/Dropping.log` -gt 24 ]
        then
        {
            sed -i '$d' ${logpath}/Dropping.log
        }
        elif [ `sed -n '$=' ${logpath}/LanError.log` -lt 24 ]
        then
        {
            echo -e "\n" >> ${logpath}/LanError.log
        }
        elif [ `sed -n '$=' ${logpath}/LanError.log` -gt 24 ]
        then
        {
            sed -i '$d' ${logpath}/LanError.log
        }
        elif [ `sed -n '$=' ${logpath}/WanError.log` -lt 24 ]
        then
        {
            echo -e "\n" >> ${logpath}/WanError.log
        }
        elif [ `sed -n '$=' ${logpath}/WanError.log` -gt 24 ]
        then
        {
            sed -i '$d' ${logpath}/WanError.log
        }
        elif [ `sed -n '$=' ${logpath}/SchoolError.log` -lt 24 ]
        then
        {
            echo -e "\n" >> ${logpath}/SchoolError.log
        }
        else
        {
            sed -i '$d' ${logpath}/SchoolError.log
        }
        fi
    }
    done

    #创建drop wan lan school组||创建等待列表
    until [ ! ${count} -lt $Quantity ]
    do
    {
        drop[${count}]=0
        wan[${count}]=0
        school[${count}]=0
        lan[${count}]=0
        waitlist[${count}]=boot
        count=`expr ${count} + 1`
    }
    done
}
fi
count=0
{
    while true
    do
    drop[${Quantity}]=`expr ${drop[${Quantity}]} + 1`
    userip=$(ifconfig ${Vth[${count}]}|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:")
    #unicom wireless
    if [ ${waitlist[$count]} == boot ];
    then
    {
        CTP=$(date +%s000)
        curl --interface ${Vth[${count}]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[${count}]}&upass=${Password[${count}]}&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
        waitlist[$count]=normal
    }
    elif [ ${waitlist[$count]} == normal ];
    then
    {
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
                        droplist[$count]=`expr $(date +%M) - 1`
                        if [ ${droplist[$count]} -eq -1 ]
                        then
                        {
                            drop[${count}]=`expr ${drop[${count}]} - 3`
                            wan[${count}]=`expr ${wan[${count}]} - 1`
                            droplist[$count]=59
                        }
                        fi
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
    elif [ ${waitlist[$count]} == $(date +%M) ]
    then
    {
        ping -I ${Vth[${count}]} -c 1 unicom.2333.ink
        if [ $? -eq 1 ];
        then
        {
            ping -I ${Vth[${count}]} -c 2 unicom.2333.ink
            if [ $? -eq 1 ];
            then
            {
                CTP=$(date +%s000)
                curl --interface ${Vth[${count}]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[${count}]}&upass=${Password[${count}]}&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
                droplist[$count]=normal
            }
            fi
        }
        fi
    }
    else
    {
        until [ $(uptime |tr -d ",.:qwertyuiopasdfghjklzxcvbnm"|awk '{print $3}') -lt `expr $(grep -c ^processor /proc/cpuinfo) \* 100` ]
        do
        {
            sleep 1s
        }
        done
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

    done
}