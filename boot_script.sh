#!/bin/bash
/usr/bin/python3 -u /home/hypermaq/scripts/queue.py -b
sleep 10
#/usr/bin/python3 -u /home/hypermaq/scripts/gpio05.py --setup
/usr/bin/python3 -u /home/hypermaq/scripts/queue.py -a set_station_params,1
sleep 30
/usr/sbin/ntpdate -b -s -u pool.ntp.org
