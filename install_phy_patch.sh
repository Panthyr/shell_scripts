#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

echo "Installing bbbphyfix."
rm -r bbbphyfix/
git clone https://github.com/bigjosh/bbbphyfix
cd bbbphyfix/ || echo "Could not enter directory, Now exiting" && exit
./install
sync

echo "Performing additional configuration."
# Check if i2c-tools is installed

if ! i2cdetect -l >/dev/null; then
    echo "i2c-tools is not installed, now installing."
    apt install i2c-tools
fi
timedatectl set-timezone UTC

echo "Done."
