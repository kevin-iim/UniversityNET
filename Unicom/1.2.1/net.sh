#vth10
{
    while true
    do
    ping -I vth10 -c 1 172.16.30.33
    if [ $? -eq 0 ];
    then
        ping -I vth10 -c 7 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            BTP=$(date)
            echo "${BTP} vth10 wan down" >> /mnt/net.log
            CTP=$(date +%s000)
            curl --interface vth10 "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=*********&upass=********&0MKKey=123456&R1=0&R3=1&R6=0&para=00&v6ip=&_=${CTP}"
        }
        fi
    else
    BTP=$(date)
    echo "${BTP} vth10 lan down" >> /mnt/net.log
    ifconfig vth10 down
    ifconfig vth10 up
    sleep 1m
    fi
    done
}&

###########################################################################################

#vth11
{
    while true
    do
    ping -I vth11 -c 1 172.16.30.33
    if [ $? -eq 0 ];
    then
        ping -I vth11 -c 7 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
            BTP=$(date)
            echo "${BTP} vth11 wan down" >> /mnt/net.log
            CTP=$(date +%s000)
            curl --interface vth11 "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=*********&upass=********&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
        }
        fi
    else
    BTP=$(date)
    echo "${BTP} vth11 lan down" >> /mnt/net.log
    ifconfig vth11 down
    ifconfig vth11 up
    sleep 1m
    fi
    done
}&

###########################################################################################
