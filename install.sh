#!/bin/sh

pacman -Sy neovim util-linux 

lsblk
echo -e "\nYou will need to have 3 partitions:\nef00 on sdx1\nROOT on sdx2\nHOME on sdx3"
read -p 'Pleas enter a disk to format (/dev/ included): ' DEV
fdisk $DEV

mkfs.fat -F 32 "${DEV}1"
mkfs.ext4 -L ROOT "${DEV}2"
mkfs.ext4 -L HOME "${DEV}3"

mount "${DEV}2" /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount "${DEV}1" /mnt/boot
mount "${DEV}3" /mnt/home

basestrap /mnt base base-devel runit eloging-runit linux linux-base
fstabgen -U /mnt >> /mnt/etc/fstab

artix-chroot /mnt
