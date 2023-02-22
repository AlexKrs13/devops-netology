#!/usr/bin/env bash

port=8080
hosts=("192.168.50.7" "192.168.50.7" "192.168.50.6")
# loop n times
while ((1==1))
do
  # loop by each host in array
  for host in ${hosts[@]}
  do
    # check port status
    nc -z $host $port >/dev/null 2>&1
    if [ "$?" != "0" ]
    then
      echo "$(date +%Y-%m-%d_%H:%M)   host=$host:$port is not available" >> host_status.log
      exit 0
    fi
  done
  # sleep
  sleep 1
done
