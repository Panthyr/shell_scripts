#!/bin/bash
sudo cp /etc/network/interfaces.dhcp /etc/network/interfaces
sudo ifdown eth0 && sudo ifup eth0
