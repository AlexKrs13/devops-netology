#!/usr/bin/env bash

port=80
hosts=("192.168.50.7" "192.168.50.7" "192.168.50.7")
# hosts loop
for host in ${hosts[@]}
do
    # 5 times hosts check loop
    i=0
    while (($i < 5))
    do
        # check hosts port status
        nc -z $host $port >/dev/null 2>&1 
        if [ "$?" != "0" ]
        then
            echo "$(date +%Y-%m-%d_%H:%M)   #$i    host=$host:$port is not available" >> host_status.log
        else    
            echo "$(date +%Y-%m-%d_%H:%M)   #$i    host=$host:$port is available" >> host_status.log
        fi
        
        let "i += 1"
    done
done
