#!/bin/bash
basepath=$(cd `dirname $0`; pwd)
num=0
count=0

#检测设置
if [ ! -d "$basepath/config" ];
then
{
    mkdir $basepath/config
    echo "未监测到配置文件"
    echo -n  "需要使用的电脑端账号数量 ->"
    read num
    if [ $num -gt 0 ]
    then
    {
        while(( $count<$num ))
        do
        echo "请先确认不同账号所对应的网卡"
        echo -n  "学号 ->"
        read PCaccount[${count}]
        echo "${PCaccount[${count}]}" >> $basepath/config/PC
        echo -n  "密码 ->"
        read PCpassword[${count}]
        echo "${PCpassword[${count}]}" >> $basepath/config/PC
        echo -n  "网卡 ->"
        read PCeth[${count}]
        echo "${PCeth[${count}]}" >> $basepath/config/PC
        echo "学号: ${PCaccount[${count}]}"
        echo "密码: ${PCpassword[${count}]}"
        echo "网卡: ${PCeth[${count}]}"
        let "count++"
        done

        if [ ${#PCaccount[*]} -ne ${#PCeth[*]} -o ${#PCeth[*]} -ne ${#PCpassword[*]} -o ${#PCpassword[*]} -ne ${#PCaccount[*]} ]
        then
        {
            echo "check not pass"
            exit
        }
        fi

        echo "检查学号密码网卡是否顺序一致"
        echo "${PCaccount[*]}"
        echo "${PCpassword[*]}"
        echo "${PCeth[*]}"
    }
    fi

    num=0
    count=0

    echo -n  "需要使用的手机端账号数量 ->"
    read num
    if [ $num -gt 0 ]
    then
    {
        while(( $count<$num ))
        do
        echo "请先确认不同账号所对应的网卡"
        echo -n  "学号 ->"
        read PHONEaccount[${count}]
        echo "${PHONEaccount[${count}]}" >> $basepath/config/PHONE
        echo -n  "密码 ->"
        read PHONEpassword[${count}]
        echo "${PHONEpassword[${count}]}" >> $basepath/config/PHONE
        echo -n  "网卡 ->"
        read PHONEeth[${count}]
        echo "${PHONEeth[${count}]}" >> $basepath/config/PHONE
        echo "学号: ${PHONEaccount[${count}]}"
        echo "密码: ${PHONEpassword[${count}]}"
        echo "网卡: ${PHONEeth[${count}]}"
        let "count++"
        done

        if [ ${#PHONEaccount[*]} -ne ${#PHONEeth[*]} -o ${#PHONEeth[*]} -ne ${#PHONEpassword[*]} -o ${#PHONEpassword[*]} -ne ${#PHONEaccount[*]} ]
        then
        {
            echo "check not pass"
            exit
        }
        fi

        echo "检查学号密码网卡是否顺序一致"
        echo "${PCaccount[*]}"
        echo "${PCpassword[*]}"
        echo "${PCeth[*]}"
    }
    fi
}
else
{

}
fi
