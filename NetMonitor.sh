logpath=/mnt/log
var=0

echo -e "\n" >> ${logpath}/Dropping.log
echo -e "\n" >> ${logpath}/load.log
until [ `sed -n '$=' ${logpath}/Dropping.log` -eq 24 -a `sed -n '$=' ${logpath}/load.log` -eq 24 ]
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
    elif [ `sed -n '$=' ${logpath}/load.log` -lt 24 ]
    then
    {
        echo -e "\n" >> ${logpath}/load.log
    }
    elif [ `sed -n '$=' ${logpath}/load.log` -gt 24 ]
    then
    {
        sed -i '$d' ${logpath}/load.log
    }
    fi
}
done

until [ ! ${var} -lt 60 ]
do
{
    drop[${var}]=0
    load[${var}]=0
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
        drop[$(date +%M)]=`expr ${drop[$(date +%M)]} + 1`
        sed -i "`expr $(date +%H) + 1`c$(date +%H)hour ${drop[*]} $(date)"  ${logpath}/Dropping.log
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

    until [ $(uptime |tr -d ",.:qwertyuiopasdfghjklzxcvbnm"|awk '{print $3}') -lt `expr $(grep -c ^processor /proc/cpuinfo) \* 100` ]
    do
    {
        sleep 1s
        load[$(date +%M)]=$(uptime |tr -d ",:qwertyuiopasdfghjklzxcvbnm"|awk '{print $3}')
        sed -i "`expr $(date +%H) + 1`c$(date +%H)hour ${load[*]} $(date)"  ${logpath}/load.log
    }
    done

    done
}&