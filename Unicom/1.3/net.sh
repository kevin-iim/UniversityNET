#!/bin/bash
Eth=(#eth)
VthA=(#vthA)
VthB=(#vthB)
Account=(#Account)
Password=(#password)
count=0
###########################################################################################
cat /dev/null > /mnt/bash/WanError.log
cat /dev/null > /mnt/bash/LanError.log
echo "WanError" >> /mnt/bash/WanError.log
echo "LanError" >> /mnt/bash/LanError.log
#A#########################################################################################
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
#B#########################################################################################
count=0

{
    while true
    do
    ping -I ${VthA[$count]} -c 1 221.5.88.88
    if [ $? -eq 1 ];
    then
    {
        ping -I ${VthA[$count]} -c 2 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            ping -I ${VthA[$count]} -c 1 172.16.30.33
            if [ $? -eq 0 ];
            then
            {
                CTP=$(date +%s000)
                curl --interface ${VthA[$count]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[$count]}&upass=${Password[$count]}&0MKKey=123456&R1=0&R3=1&R6
                BTP=$(date)
                sed -i "1i${BTP} ${Account[$count]} ${VthA[$count]}" /mnt/bash/WanError.log
            }
            else
            {
                ifconfig ${VthA[$count]} down
                ifconfig ${VthA[$count]} up
                BTP=$(date)
                sed -i "1i${BTP} ${Account[$count]} ${VthA[$count]}" /mnt/bash/LanError.log
                CTP=$(date +%s000)
                curl --interface ${VthA[$count]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[$count]}&upass=${Password[$count]}&0MKKey=123456&R1=0&R3=1&R6
            }
            fi
        }
        fi
    }
    fi
#################################################################################################################################################################################
    ping -I ${VthB[$count]} -c 1 221.5.88.88
    if [ $? -eq 1 ];
    then
    {
        ping -I ${VthB[$count]} -c 2 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            ping -I ${VthB[$count]} -c 1 172.16.30.33
            if [ $? -eq 0 ];
            then
            {
                CTP=$(date +%s000)
                curl --interface ${VthB[$count]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[$count]}&upass=${Password[$count]}&0MKKey=123456&R1=0&R3=1&R6
                BTP=$(date)
                sed -i "1i${BTP} ${Account[$count]} ${VthA[$count]}" /mnt/bash/WanError.log
            }
            else
            {
                ifconfig ${VthB[$count]} down
                ifconfig ${VthB[$count]} up
                BTP=$(date)
                sed -i "1i${BTP} ${Account[$count]} ${VthA[$count]}" /mnt/bash/LanError.log
                CTP=$(date +%s000)
                curl --interface ${VthB[$count]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[$count]}&upass=${Password[$count]}&0MKKey=123456&R1=0&R3=1&R6
            }
            fi
        }
        fi
    }
    fi

    count=`expr $count + 1`
    if [ "$count" -eq 3 ];
    then
    {
        count=0
    }
    fi

    done
}&
