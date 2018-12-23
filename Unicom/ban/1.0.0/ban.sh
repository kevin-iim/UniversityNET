#vth0
{
    while true
    do
    ping -I vth0 -c 1 172.16.30.33
    if [ $? -eq 0 ];
    then
        ping -I vth0 -c 7 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            BTP=$(date)
            echo "${BTP} vth0 wan down" >> /mnt/net.log
            sleep ${val0}s
            CTP=$(date +%s000)
            curl --interface vth0 "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=*********&upass=********&0MKKey=123456&R1=0&R3=1&R6=0&para=00&v6ip=&_=${CTP}"
            val0=`expr $(date +%M) \* $(date +%S) \* $(date +%w) + $(date +%j)`
            echo "val0 ${val0} in ${BTP}" >> /mnt/ban.log
        }
        fi
    else
    BTP=$(date)
    echo "${BTP} vth0 lan down" >> /mnt/net.log
    fi
    done
}&

###########################################################################################

#vth1
{
    while true
    do
    ping -I vth1 -c 1 172.16.30.33
    if [ $? -eq 0 ];
    then
        ping -I vth1 -c 7 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            BTP=$(date)
            echo "${BTP} vth1 wan down" >> /mnt/net.log
            sleep ${val1}s
            CTP=$(date +%s000)
            curl --interface vth1 "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=*********&upass=********&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
            val1=`expr $(date +%M) \* $(date +%S) \* $(date +%w) + $(date +%j)`
            echo "val1 ${val1} in ${BTP}" >> /mnt/ban.log
        }
        fi
    else
    BTP=$(date)
    echo "${BTP} vth1 lan down" >> /mnt/net.log
    fi
    done
}&
