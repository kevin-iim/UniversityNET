while true
do

###########################################################################################

#vth10
ping -I vth10 -c 2 172.16.30.33
if [ $? -eq 0 ];
then
        ping -I vth10 -c 3 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
                BTP=$(date)
                echo "vth10 wan 3 ${BTP}" >> /mnt/net.log
                CTP=$(date +%s000)
                curl --interface vth10 "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=*********&upass=********&0MKKey=123456&R1=0&R3=1&R6=0&para=00&v6ip=&_=${CTP}"
        }&
        fi
else
BTP=$(date)
echo "vth10 lan ${BTP}" >> /mnt/net.log
fi

###########################################################################################

#vth11
ping -I vth11 -c 2 172.16.30.33
if [ $? -eq 0 ];
then
        ping -I vth11 -c 3 221.5.88.88
        if [ $? -eq 1 ];
        then
        {
                BTP=$(date)
                echo "vth11 wan 3 ${BTP}" >> /mnt/net.log
                CTP=$(date +%s000)
                curl --interface vth11 "http://172.16.30.33/drcom/login?callback=dr${CTP}&DDDDD=*********&upass=********&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${CTP}"
        }&
        fi
else
BTP=$(date)
echo "vth11 lan ${BTP}" >> /mnt/net.log
fi

###########################################################################################
wait
done
