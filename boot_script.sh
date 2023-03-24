#!/bin/bash
/usr/bin/python3 -u /home/panthyr/repos/panthyr_core/p_core/queue/queue.py -B
sleep 30
/usr/bin/python3 -u /home/panthyr/repos/panthyr_core/p_core/queue/queue.py -a set_station_params,1
