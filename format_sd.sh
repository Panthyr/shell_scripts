#! /bin/bash

GREEN='\033[1;32m'
NC='\033[0m'

check_if_root()
{
    if [ "$EUID" -ne 0 ]
       then
            echo "Please run as root"
        exit
    fi
}

create_partition()
{
    sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk --wipe always /dev/mmcblk0
    o # clear partition table
    n # new partition
    p # primary partition
    1 # partition number 1
      # default - start at beginning of disk
      # start partition at start of disk
      # extend partition to end of disk
    w # write
    q # quit
EOF
}

create_directories()
{
echo -e "${GREEN}Creating directories and mounting card${NC}"
mkdir /mnt/sd_card
mount /dev/mmcblk0p1 /mnt/sd_card
mkdir -p /mnt/sd_card/data/images
mkdir -p /mnt/sd_card/data/logs
chown -R panthyr:panthyr /mnt/sd_card
chmod 775 -R /mnt/sd_card
}

format_to_ext4()
{
if [ "$1" = "fast" ]
    then
        echo -e "${GREEN}--------------------------------------------------------------"
        echo "Formatting /dev/mmcblk0 to EXT4 WITHOUT CHECKING FOR BAD BLOCKS."
        echo "If the command warns the disk contains a file system or partition table, proceed anyway."
        echo -e "--------------------------------------------------------------${NC}"
        mke2fs -L panthyr_sd -t ext4 /dev/mmcblk0p1
    else
        echo -e "${GREEN}--------------------------------------------------------------"
        echo "Formatting /dev/mmcblk0 to EXT4"
        echo "If the command warns the disk contains a file system or partition table, proceed anyway."
        echo -e "--------------------------------------------------------------${NC}"
        mke2fs -c -L panthyr_sd -t ext4 /dev/mmcblk0p1
fi
}

check_if_root
umount /dev/mmcblk0p1
create_partition
format_to_ext4 "$@"
create_directories

echo -e ""
echo -e "${GREEN}Add to /etc/fstab:"
echo -e "/dev/mmcblk0p1 /mnt/sd_card ext4 defaults,auto,users,rw,nofail,x-systemd.device-timeout=15 0 0${NC}"