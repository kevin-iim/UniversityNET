#telecom
ping -I ${Vth[${count}]} -c 1 telecom.2333.ink
if [ $? -eq 1 ];
then
{
    ping -I ${Vth[${count}]} -c 2 telecom.2333.ink
    if [ $? -eq 1 ];
    then
    {
        ping -I ${Vth[${count}]} -c 1 183.6.14.7.29
        if [ $? -eq 1 ];
        then
        {
            ping -I ${Vth[${count}]} -c 1 202.96.128.166
            if [ $? -eq 0 ];
            then
            {
                curl --interface ${Vth[${count}]} -s -d "userid=${Account[${count}]}@NFSYSU.GZ&passwd=${Password[${count}]}&wlanuserip=${userip}&wlanacname=nfsysugz2&auth_type=PAP&wlanacIp=183.6.109.10" --user-agent "Supplicant" "http://219.136.125.139/portalAuthAction.do"
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