#!/bin/bash
Eth=())
VthA=()
VthB=()
Account=()
Password=()
WT=(null null null) #等待列表
row=0 #行数统计
count=0 #0-3循环
drop=(0 0 0) #丢ping统计
not=1 #1-3循环
#time 等待时间
###########################################################################################
echo -e "\n" >> /mnt/bash/WanError.log
echo -e "\n" >> /mnt/bash/LanError.log
echo -e "\n\n\n" >> /mnt/bash/time.log
echo -e "\n\n\n" >> /mnt/bash/dropping.log
###########################################################################################
until [ ! $count -lt 3 ]
do
{
    ip link add link ${Eth[$count]} name ${VthA[$count]} type macvlan
    ifconfig ${VthA[$count]} up
    count=`expr $count + 1`
}
done

count=0

until [ ! $count -lt 3 ]
do
{
    ip link add link ${Eth[$count]} name ${VthB[$count]} type macvlan
    ifconfig ${VthB[$count]} up
    count=`expr $count + 1`
}
done
###########################################################################################

count=0

{
    while true
    do
    ping -I ${VthA[$count]} -c 1 221.5.88.88
    if [ $? -eq 1 ];
    then
    {
        BTP=$(date)
        drop[$count]=`expr ${drop[$count]} + 1`
        sed -i "${not}c${drop[$count]} ${BTP}" /mnt/bash/dropping.log
        sed -i "4c${drop[*]}" /mnt/bash/dropping.log
        ping -I ${VthA[$count]} -c 2 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            ping -I ${VthA[$count]} -c 1 172.16.30.33
            if [ $? -eq 0 ];
            then
            {
                CTP=$(date +%s000)
                curl --interface ${VthA[$count]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[$count]}&upass=${Password[$count]}&0MKKey=123456&R1=0&R3=1&R6=0&para=00&v6ip=&_=${CTP}"
                row=`sed -n '$=' /mnt/bash/WanError.log`
                if [ $row -ge 100 ]
                then
                {
                    sed -i '$d' /mnt/bash/WanError.log
                }
                fi
                BTP=$(date)
                sed -i "1i${BTP} ${Account[$count]} ${VthA[$count]}" /mnt/bash/WanError.log
            }
            else
            {
                ifconfig ${VthA[$count]} down
                ifconfig ${VthA[$count]} up
                row=`sed -n '$=' /mnt/bash/LanError.log`
                if [ $row -ge 100 ]
                then
                {
                    sed -i '$d' /mnt/bash/LanError.log
                }
                fi
                BTP=$(date)
                sed -i "1i${BTP} ${Account[$count]} ${VthA[$count]}" /mnt/bash/LanError.log
            }
            fi
        }
        fi
    }
    fi

######################################################################################################################################################################################

    if [ ${WT[$count]} == null ];
    then
    {
        ping -I ${VthB[$count]} -c 1 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            curl --interface ${VthB[$count]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[$count]}&upass=${Password[$count]}&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
            WT[$count]=wt$count
        }
        fi
    }
    elif [ ${WT[$count]} == wt$count ];
    then
    {
        ping -I ${VthB[$count]} -c 1 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            drop[$count]=`expr ${drop[$count]} + 1`
            BTP=$(date)
            sed -i "${not}c${drop[$count]} ${BTP}" /mnt/bash/dropping.log
            sed -i "4c${drop[*]}" /mnt/bash/dropping.log
            ping -I ${VthB[$count]} -c 2 221.5.88.88
            if [ $? -eq 1 ];
            then
            {
                ping -I ${VthB[$count]} -c 1 172.16.30.33
                if [ $? -eq 0 ];
                then
                {
                    cmin=`expr $(date +%M) - 1`
                    if [ $cmin -eq -1 ]
                    then
                    {
                        cmin=59
                    }
                    fi
                    CTP=$(date +%s000)
                    curl --interface ${VthB[$count]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[$count]}&upass=${Password[$count]}&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
                    row=`sed -n '$=' /mnt/bash/WanError.log`
                    if [ $row -ge 100 ]
                    then
                    {
                        sed -i '$d' /mnt/bash/WanError.log
                    }
                    fi
                    BTP=$(date)
                    sed -i "1i${BTP} ${Account[$count]} ${VthB[$count]}" /mnt/bash/WanError.log
                    WT[$count]=$cmin
                }
                else
                {
                    ifconfig ${VthB[$count]} down
                    ifconfig ${VthB[$count]} up
                    row=`sed -n '$=' /mnt/bash/LanError.log`
                    if [ $row -ge 100 ]
                    then
                    {
                        sed -i '$d' /mnt/bash/LanError.log
                    }
                    fi
                    BTP=$(date)
                    sed -i "1i${BTP} ${Account[$count]} ${VthB[$count]}" /mnt/bash/LanError.log
                }
                fi
            }
            fi
        }
        fi
    }
    elif [ ${WT[$count]} == $(date +%M) ];
    then
    {
        ping -I ${VthB[$count]} -c 1 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            ping -I ${VthB[$count]} -c 1 172.16.30.33
            if [ $? -eq 0 ];
            then
            {
                CTP=$(date +%s000)
                curl --interface ${VthB[$count]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[$count]}&upass=${Password[$count]}&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
                WT[$count]=wt$count
            }
            else
            {
                ifconfig ${VthB[$count]} down
                ifconfig ${VthB[$count]} up
                row=`sed -n '$=' /mnt/bash/LanError.log`
                if [ $row -ge 100 ]
                then
                {
                    sed -i '$d' /mnt/bash/LanError.log
                }
                fi
                BTP=$(date)
                sed -i "1i${BTP} ${Account[$count]} ${VthB[$count]}" /mnt/bash/LanError.log
                sleep 10s
                CTP=$(date +%s000)
                curl --interface ${VthB[$count]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[$count]}&upass=${Password[$count]}&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
                WT[$count]=wt$count
            }
            fi
        }
        fi
    }
    else
    {
        sed -i "${not}c${BTP} ${WT[$count]}" /mnt/bash/time.log
        sed -i "4c${WT[*]}" /mnt/bash/time.log
    }
    fi

    count=`expr $count + 1`
    if [ "$count" -eq 3 ];
    then
    {
        count=0
    }
    fi

    not=`expr $not + 1`
    if [ "$not" -eq 4 ];
    then
    {
        not=1
    }
    fi

    done
}&