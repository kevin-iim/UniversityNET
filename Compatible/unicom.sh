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
        ping -I ${Vth[${count}]} -c 2 unicom.2333.ink
        if [ $? -eq 1 ];
        then
        {
            ping -I ${Vth[${count}]} -c 1 210.21.79.129
            if [ $? -eq 1 ];
            then
            {
                ping -I ${Vth[${count}]} -c 1 172.16.30.33
                if [ $? -eq 0 ];
                then
                {
                    droplist[$count]=doublecheck
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
        fi
    }
    fi
}
elif [ ${waitlist[$count]} == doublecheck ]
then
{
    ping -I ${Vth[${count}]} -c 1 unicom.2333.ink
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
    }
    else
    {
        droplist[$count]=normal
    }
    fi
}
elif [ ${waitlist[$count]} == $(date +%M) ]
then
{
    CTP=$(date +%s000)
    curl --interface ${Vth[${count}]} "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=${Account[${count}]}&upass=${Password[${count}]}&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
    droplist[$count]=normal
}
else
{
    until [ $(uptime |tr -d "up"|tr -d ",.:qwertyuiopasdfghjklzxcvbnm"|awk '{print $3}') -lt `expr $(grep -c ^processor /proc/cpuinfo) \* 100` ]
    do
    {
        sleep 1s
    }
    done
}
fi