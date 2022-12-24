# note

## base

https://wiki.archlinux.org/index.php/Installation_guide

## preparing installatin media

```console
lsblk

sudo dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync
```

## install script

Note: replace ${_VARIABLE} as appropriate value for environment

keyboard layout

```console
ls /usr/share/kbd/keymaps/**/*.map.gz

# when using JIS keyboard ( US is default )
loadkeys jp106
```

check network ( wifi )

```console
rfkill list

# when Wi-Fi device is soft-blocked
rfkill unblock ${WIFI_DEVICE_ID}

ip link
wifi-menu ${_NETWORK_DEVICENAME}
```

system clock

```console
timedatectl set-ntp true
```

disk partitioning ( UEFI + GPT )

```console
# e.g.
#  partition | mount point | filesystem
#  /dev/sda1 | /boot       | ef00 ( EFI system partition )
#  /dev/sda2 | /           | 8300 ( Linux filesystem )
#  /dev/sda3 | /home       | 8300 ( Linux filesystem )

sgdisk  -z /dev/sda
sgdisk -n 1::+512M -t 1:ef00 -c 1:"EFI system partition ( /boot )" /dev/sda
sgdisk -n 2::+64G -t 2:8300 -c 2:"Linux filesystem ( / )" /dev/sda
sgdisk -n 3:: -t 2:8300 -c 3:"Linux filesystem ( /home )" /dev/sda

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
reflector --country Japan --protocol https --age 24 --completion-percent 95 --sort rate --save /etc/pacman.d/mirrorlist
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

pacman

```console
cp -pi /etc/pacman.conf /etc/pacman.conf.orig

sed -i -e 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
sed -i -e 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i -e 's/^#Color/Color/' /etc/pacman.conf
```

microcode

```console
# when using intel CPU
pacman -S \
  intel-ucode \
  xf86-video-intel \
  mesa

# when using AMD CPU
pacman -S \
  amd-ucode \
  xf86-video-amdgpu \
  mesa
```

boot loader

```console
bootctl install

cat >> /boot/loader/loader.conf << __EOF__
default archlinux
timeout 5
editor no
__EOF__

cat >> /boot/loader/entries/archlinux.conf << __EOF__
title   Arch Linux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID="xxxx" rw noefi
__EOF__

BLKID_ROOT=`blkid --match-tag PARTUUID ${_ROOT_PARTION} | awk -F\" '{print $2}'`
sed -i -e 's/xxxx/${BLKID_ROOT}/' /boot/loader/entries/archlinux.conf
cat /boot/loader/entries/archlinux.conf

cp -i /boot/loader/entries/archlinux.conf /boot/loader/entries/archlinux-lts.conf
sed -i -e 's/Linux/Linux (LTS)/' /boot/loader/entries/archlinux-lts.conf
sed -i -e 's/-linux/-linux-lts/g' /boot/loader/entries/archlinux-lts.conf
diff -u /boot/loader/entries/archlinux.conf /boot/loader/entries/archlinux-lts.conf
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
# when using intel CPU
-----
-MODULES=()
+MODULES=(i915)
-----
# When using AMD CPU
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

exit
```

reboot

```console
exit
reboot
```

