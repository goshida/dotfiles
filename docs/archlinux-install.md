# note

## base

https://wiki.archlinux.org/index.php/Installation_guide

## preparing installatin media

```console
sudo dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync
```

## install script

keyboard layout ( jis layout )

```console
ls /usr/share/kbd/keymaps/**/*.map.gz
loadkeys jp106
```

check network ( wifi )

```console
ip link
rfkill list
rfkill unblock 0
wifi-menu ${_DEVICENAME}
```

system clock

```console
timedatectl set-ntp true
```

disk partitioning ( UEFI + GPT )

```console
# sample
#  sda1 : /boot : ef00 ( EFI system partition )
#  sda2 : / : 8300 ( Linux filesystem )
#  sda3 : /home : 8300 ( Linux filesystem )

gdisk /dev/sda

mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3

mount /dev/sda2 /mnt
mkdir /mnt/boot
mkdir /mnt/home

mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home
```

mirrorlist

```console
vi /etc/pacman.d/mirrorlist
```

pacstrap

```console
pacstrap /mnt \
  base \
  base-devel \
  linux \
  linux-lts \
  linux-firmware \
  dhcpcd \
  vi \
  sudo \
  git
```

fstab

```console
genfstab -U /mnt >> /mnt/etc/fstab
```

chroot

```console
arch-chroot /mnt
```

etcetera

```console
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

hwclock --systohc --utc

vi /etc/locale.gen
-----
-# en_US.UTF-8 UTF-8
+en_US.UTF-8 UTF-8
-----
-# ja_JP.UTF-8 UTF-8
+ja_JP.UTF-8 UTF-8
-----

locale-gen

echo 'LANG=en_US.UTF-8' >> /etc/locale.conf

echo ${_HOSTNAME} > /etc/hostname

vi /etc/hosts
-----
127.0.0.1 localhost
::1       localhost
127.0.0.1 ${_HOSTNAME}.localdomain ${_HOSTNAME}
-----

mkinitcpio -P

passwd

systemctl enable dhcpcd.service
```

microcode

```console
pacman -S \
  intel-ucode \
  xf86-video-intel \
  mesa

pacman -S \
  amd-ucode \
  xf86-video-amdgpu \
  mesa
```

boot loader

```console
bootctl install

cat >> /boot/loader/loader.conf << __EOF__
default arch
timeout 5
editor no
__EOF__

cat >> /boot/loader/entries/arch.conf << __EOF__
title   Arch Linux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" rw noefi
__EOF__

blkid /dev/[root-partition] >> /boot/loader/entries/arch.conf
vi /boot/loader/entries/arch.conf
```

swap file

```console
dd if=/dev/zero of=/swapfile bs=1M count=8192
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

cat >> /etc/fstab << __EOF__

# swap
/swapfile none swap defaults 0 0
__EOF__

sysctl vm.swappiness=10
echo 'vm.swappiness=10' >> /etc/sysctl.d/99-sysctl.conf
```

KMS

```console
vi /etc/mkinitcpio.conf
-----
-MODULES=()
+MODULES=(i915)
-----
-MODULES=()
+MODULES=(amdgpu)
-----

mkinitcpio -p linux
```

sudo

```console
EDITOR=vi visudo
-----
-# %wheel ALL=*ALL:ALL) ALL
+%wheel ALL=*ALL:ALL) ALL
-----
```

user

```console
useradd -G wheel -s /bin/bash -m ${_USERNAME}
passwd ${_USERNAME}
```

yay

```console
su - ${_USERNAME}
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay/
makepkg -si
cd ~/
rm -rf ~/yay/
```

reboot

```console
exit
reboot
```

