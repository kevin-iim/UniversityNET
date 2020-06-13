#!/bin/bash
basepath=$(cd `dirname $0`; pwd)
count=0

#检测设置
if [ ! -d "$basepath/log" ];
then
{
    mkdir $basepath/log
}
elif [ ! -f "$basepath/config.json" ];
then
{
    echo "未监测到配置文件"
    echo -n  "需要使用的电脑端账号数量 ->"
}