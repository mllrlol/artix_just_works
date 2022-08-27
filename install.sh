#!/bin/sh

pacman -Sy neovim util-linux 

echo -e "\n\nYou will need 3 partitions:\n\033[1;34mef00 on sdx1\n\033[1;35mROOT on sdx2\n\033[0;37mHOME on sdx3\033[0m"
lsblk
read -p 'Pleas enter a disk to be format ("/dev/" \033[0;31mNOT\033[0m included): ' DEV
fdisk "/dev/${DEV}"

mkfs.fat -F 32 "${DEV}1"
mkfs.ext4 -L ROOT "${DEV}2"
mkfs.ext4 -L HOME "${DEV}3"

mount "/dev/${DEV}2" /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount "/dev/${DEV}1" /mnt/boot
mount "/dev/${DEV}3" /mnt/home

basestrap /mnt base base-devel runit elogind-runit
basestrap /mnt linux linux-firmware
fstabgen -U /mnt >> /mnt/etc/fstab

artix-chroot /mnt

read -p 'Pleas enter a Region/City: ' ZONEINFO
ln -sf "/usr/share/zoneinfo/${ZONEINFO}" /etc/localtime

hwclock --systohc

pacman -S neovim
nvim /etc/local.gen
local-gen

pacman -S grub os-prober efibootmgr
grub-install --recheck /dev/sda
grub-install --target=x86_64 --efi-directory=/boot --bootloader-id=grub

passwd

read -p 'Enter a hostname: ' HOSTNAME
echo $HOSTNAME > /etc/hostname
echo "127.0.0.1	localhost\n::1	localhost\n127.0.1.1	${HOSTNAME}.localdomain	${HOSTNAME}"

pacman -S connman-runit connman-gtk elogind
ln -s /etc/runit/sv/connmand /etc/runit/runsvdir/default

echo "System install finished"
