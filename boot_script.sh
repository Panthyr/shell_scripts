#!/bin/bash
/usr/bin/python3 -u /home/panthyr/repos/panthyr_core/p_core/queue/queue.py --booted
sleep 30
/usr/bin/python3 -u /home/panthyr/repos/panthyr_core/p_core/queue/queue.py --set_station_parameters
