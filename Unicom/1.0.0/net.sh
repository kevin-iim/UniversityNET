##################################################################
currentTimeStamp=$(date +%s000)

##########
ping -I vth0 -c 1 1.2.4.8
if [ $? -eq 1 ];then
curl --interface macvlan1 "http://172.16.30.33/drcom/login?callback=dr${currentTimeStamp}&DDDDD=学号&upass=密码&0MKKey=123456&R1=0&R3=1&R6=0&para=00&v6ip=&_=${currentTimeStamp}"
else
echo Network OK
fi

##########
ping -I vth1 -c 1 1.2.4.8
if [ $? -eq 1 ];then
curl --interface macvlan1 "http://172.16.30.33/drcom/login?callback=dr${currentTimeStamp}&DDDDD=学号&upass=密码&0MKKey=123456&R1=0&R3=1&R6=1&para=00&v6ip=&_=${currentTimeStamp}"
else
echo Network OK
fi
