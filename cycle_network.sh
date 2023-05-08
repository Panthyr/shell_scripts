#! /bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

echo -n "Powering down network interface eth0... "
ifdown eth0 >/dev/null 2>&1
echo -e "\e[32mDONE\e[39m"
echo -n "Powering up network interface eth0... "
ifup eth0 >/dev/null 2>&1
echo -e "\e[32mDONE\e[39m"

echo ""
echo "Current config:"
ifconfig eth0 | grep inet | grep -v inet6 | sed -e 's/^[ \t]*//' # s/ substitute, ^ at start of line, [\t]* one or more blank spaces, // replace (delete)
