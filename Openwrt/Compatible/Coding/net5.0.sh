#!/bin/bash
basepath=$(cd `dirname $0`; pwd)
num=0
count=0

#检测设置
if [ ! -d "$basepath/log" ];
then
{
    mkdir $basepath/log
}
fi

if [ ! -f "$basepath/config.sh" ];
then
{
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
        echo -n  "密码 ->"
        read PCpassword[${count}]
        echo -n  "网卡 ->"
        read PCeth[${count}]
        echo "学号: ${PCaccount[${count}]}"
        echo "密码: ${PCpassword[${count}]}"
        echo "网卡: ${PCeth[${count}]}"
        let "count++"
        done

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
        echo -n  "密码 ->"
        read PHONEpassword[${count}]
        echo -n  "网卡 ->"
        read PHONEeth[${count}]
        echo "学号: ${PHONEaccount[${count}]}"
        echo "密码: ${PHONEpassword[${count}]}"
        echo "网卡: ${PHONEeth[${count}]}"
        let "count++"
        done

        echo "检查学号密码网卡是否顺序一致"
        echo "${PCaccount[*]}"
        echo "${PCpassword[*]}"
        echo "${PCeth[*]}"
    }
    fi
}
fi