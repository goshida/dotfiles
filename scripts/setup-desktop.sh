#!/usr/bin/env bash

set -eux

_DOTFILES_ROOT=$( cd $( dirname $0 )/../ && pwd )

_SETUP_TIMESTAMP=`date +%Y%m%d-%H%M%S`

# pacman
sudo cp -p /etc/pacman.conf /etc/pacman.conf.${_SETUP_TIMESTAMP}
sudo install -o root -g root -m 644 -D ${_DOTFILES_ROOT}/etc/pacman.conf /etc/pacman.conf

# sudo
sudo cp -p /etc/sudoers /etc/sudoers.${_SETUP_TIMESTAMP}
sudo sh -c "cat ${_DOTFILES_ROOT}/etc/sudoers | EDITOR=tee visudo"

# firewall
sudo cp -p /etc/nftables.conf /etc/nftables.conf.${_SETUP_TIMESTAMP}
sudo install -o root -g root -m 644 -D ${_DOTFILES_ROOT}/etc/nftables.conf /etc/nftables.conf
sudo systemctl enable nftables

# gui
sudo systemctl enable lightdm.service
cp --backup=simple /etc/X11/xinit/xinitrc /home/${USER}/.xinitrc
libinput-gestures-setup autostart

# bluetooth
sudo systemctl enable bluetooth

# docker
sudo systemctl enable docker
sudo usermod -aG docker ${USER}

# additional-settings
sudo localectl --no-convert set-x11-keymap us pc104 "" ctrl:nocaps

