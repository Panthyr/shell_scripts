#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo -ne "\e[31mPlease run as root. Exiting..."
    exit
fi

echo -ne "\e[33mPlease enter new hostname (no special characters!) and press Enter:\n"
read -r new_hostname

if [ "$new_hostname" = "" ]; then
    echo -ne "\e[31mPlease provide new hostname. Exiting..."
    exit
fi

cat >"/etc/hosts" <<EOF
127.0.0.1   localhost localhost.localdomain $new_hostname

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

echo "$new_hostname" >/etc/hostname

if ! /bin/hostname -F /etc/hostname; then
    echo -ne "\e[31m\n"
    echo "***************************"
    echo "Error, please set another hostname. Do NOT restart before setting a correct hostname!"
    echo "***************************"
    exit
fi

echo -ne "\e[32mDone. New hostname \" $new_hostname \" will be in use after reboot."
