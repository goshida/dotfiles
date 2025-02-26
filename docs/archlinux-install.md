# note

Note: replace ${_VARIABLE} as appropriate value


## base

https://wiki.archlinux.org/index.php/Installation_guide


## preparing installatin media

download image and verify signature

```console
cd ~/Downloads/
curl -O http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/iso/latest/archlinux-x86_64.iso
curl -O http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/iso/latest/archlinux-x86_64.iso.sig

gpg --keyserver-options auto-key-retrieve --verify archlinux-x86_64.iso.sig
# https://archlinux.org/people/developers/
```

write image to media

```console
lsblk
sudo dd bs=4M if=~/Downloads/archlinux-x86_64.iso of=/dev/${_INSTALL_MEDIA} status=progress oflag=sync
```


## install script

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

iwctl device list
iwctl station ${_NETWORK_DEVICENAME} scan
iwctl station ${_NETWORK_DEVICENAME} get-networks
iwctl station ${_NETWORK_DEVICENAME} connect ${_SSID}
```

system clock

```console
timedatectl set-ntp true
```

disk partitioning ( LVM on LUKS )

```console
lsblk

# partitioning
sgdisk -z /dev/nvme0n1
sgdisk -n 1::+1G -t 1:ef00 -c 1:"EFI system partition ( /boot )" /dev/nvme0n1
sgdisk -n 2:: -t 2:8e00 -c 2:"Linux LVM" /dev/nvme0n1

# LUKS
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup open --type luks /dev/nvme0n1p2 cryptlvm

# LVM setup
pvcreate /dev/mapper/cryptlvm
vgcreate VG1 /dev/mapper/cryptlvm
lvcreate -n root -L 128G VG1
lvcreate -n home -L 512G VG1

# filesystem
mkfs.vfat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/mapper/VG1-root
mkfs.ext4 /dev/mapper/VG1-home

# mount
mount /dev/mapper/VG1-root
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/nvme0n1p1 /mnt/boot
mount /dev/mapper/VG1-home /mnt/home
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
  cryptsetup \
  lvm2 \
  vi \
  sudo \
  networkmanager \
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

passwd

systemctl enable NetworkManager.service
```

pacman

```console
cp -pi /etc/pacman.conf /etc/pacman.conf.`date +%Y%m%d`

sed -i -e 's/^#Color/Color/' /etc/pacman.conf
sed -i -e 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
sed -i -e 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
```

microcode

```console
lscpu
lspci -k | grep -A 2 -E "(VGA|3D)"

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
BLKID_ROOT=`blkid --match-tag UUID ${_LUKS_PARTITION_DEVICE}`
sed -i -e "s/xxxx/${BLKID_ROOT}/" /boot/loader/entries/archlinux.conf
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
+MODULES=(tpm_tis? i915)
-----
# when using AMD CPU
-----
-MODULES=()
+MODULES=(tpm_tis? amdgpu)
-----
#HOOKS
-----
-HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)
+HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)

mkinitcpio -P
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

reboot

```console
exit
reboot
```

