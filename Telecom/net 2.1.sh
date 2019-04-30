    #!/bin/bash
    Eth=()
    Vth=()
    Account=()
    Password=()
    count=0
    routerip=10.192.168.225
    ###########################################################################################
    until [ ! $count -lt 4 ]
    do
    {
        ip link add link ${Eth[$count]} name ${Vth[$count]} type macvlan
        ifconfig ${Vth[$count]} up
        count=`expr $count + 1`
    }
    done
    ###########################################################################################

    count=0
    not=5
    until [ ! $count -lt 4 ]
    do
    {
        userip=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|grep -v 10.192.168.225|sed -n "${not}p")
        curl --interface ${Vth[$count]} -s -d "userid=${Account[$count]}@NFSYSU.GZ&passwd=${Password[$count]}&wlanuserip=${userip}&wlanacname=nfsysugz2&auth_type=PAP&wlanacIp=183.6.109.10" --user-agent "Supplicant" "http://219.136.125.139/portalAuthAction.do"
        count=`expr $count + 1`
        not=`expr $not + 1`
    }
    done

    #183.6.147.29外网
    #202.96.128.86内网