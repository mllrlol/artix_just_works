# artix_just_works

*A command line artix linux install helper*

This tool only gives you a *very* bare-bones, Runit install of artix linux based on the [wiki](https://wiki.artixlinux.org/Main/Installation).

## Getting started
Switch to root (if you don't want use ```sudo```):
```
su
```

Download git and clone the repo:
```
pacman -Sy git
git clone https://github.com/mllrlol/artix_just_works
```

Mark ```install.sh``` as exetutable and run it:
```
cd artix_just_works
chmod +x install.sh
./install.sh
```
## After running the script
Because this is truely a bare-bones install you might want to proceed with things like this:

### Adding users
Set the password of root:
```
passwd
```

Create regular user (with home directory):
```
useradd -m user
passwd user
```

### Localization
Install a text editor of your choice (my recomedations are: vi, vim, neovim) and edit ```/etc/local.gen```

```
pacman -S neovim
nvim /etc/local.gen
```

Generate your locales:
```
locale-gen
```

### Boot Loader
Install grub:
```
pacman -S grub os-prober efibootmgr
 grub-install --recheck /dev/sda                                               # for BIOS systems
 grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub   # for UEFI systems
 grub-mkconfig -o /boot/grub/grub.cfg
```
