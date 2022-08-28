#!/bin/sh

pacman -Sy neovim util-linux 

echo -e "\n\nYou will need 3 partitions:\n\033[1;34mef00 on sdx1\n\033[1;35mROOT on sdx2\n\033[0;37mHOME on sdx3\033[0m"
lsblk
read -p $'Pleas enter a disk to be format ("/dev/" \e[31mNOT\e[0m included): ' DEV
fdisk "/dev/${DEV}"

mkfs.fat -F 32 "/dev/${DEV}1"
mkfs.ext4 -L ROOT "/dev/${DEV}2"
mkfs.ext4 -L HOME "/dev/${DEV}3"

mount "/dev/${DEV}2" /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount "/dev/${DEV}1" /mnt/boot
mount "/dev/${DEV}3" /mnt/home

basestrap /mnt base base-devel runit elogind-runit
basestrap /mnt linux linux-firmware
fstabgen -U /mnt >> /mnt/etc/fstab

read -p 'Pleas enter a Region/City: ' ZONEINFO
ln -sf "/mnt/usr/share/zoneinfo/${ZONEINFO}" /mnt/etc/localtime

read -p 'Enter a hostname: ' HOSTNAME
echo $HOSTNAME > mnt/etc/hostname
echo "127.0.0.1	localhost\n::1	localhost\n127.0.1.1	${HOSTNAME}.localdomain	${HOSTNAME}" > /mnt/etc/hosts

echo "Sytem install finished, chroot into install"
artix-chroot /mnt
