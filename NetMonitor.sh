logpath=/mnt/log
var=0

echo -e "\n" >> ${logpath}/Dropping.log
until [ `sed -n '$=' ${logpath}/Dropping.log` -eq 24 ]
do
{
    if [ `sed -n '$=' ${logpath}/Dropping.log` -lt 24 ]
    then
    {
        echo -e "\n" >> ${logpath}/Dropping.log
    }
    elif [ `sed -n '$=' ${logpath}/Dropping.log` -gt 24 ]
    then
    {
        sed -i '$d' ${logpath}/Dropping.log
    }
    fi
}
done

until [ ! ${var} -lt 60 ]
do
{
    drop[${var}]=0
    var=`expr ${var} + 1`
}
done
var=0

{
    while true
    do

    ping -c 1 10000.gd.cn
    if [ $? -eq 1 ];
    then
    {
        drop[$((10#$(date +%M)))]=`expr ${drop[$((10#$(date +%M)))]} + 1`
    }
    fi

    if [ $(date +%M) == 00 ];
    then
    {
        if [ $(var) == 0 ];
        then
        {
            until [ ! ${var} -lt 60 ]
            do
            {
                drop[${var}]=0
                var=`expr ${var} + 1`
            }
            done
        }
        fi
    }
    elif [ $(date +%M) == 01 ];
    then
    {
        var=0
    }
    fi

    sed -i "`expr $((10#$(date +%H))) + 1`c$((10#$(date +%H)))hour ${drop[*]} $(date)"  ${logpath}/Dropping.log

    until [ $(uptime |tr -d ",.:qwertyuiopasdfghjklzxcvbnm"|awk '{print $5}') -lt `expr $(grep -c ^processor /proc/cpuinfo) \* 100` ]
    do
    {
        sleep 1s
    }
    done

    done
}&