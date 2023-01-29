#!/usr/bin/env bash

set -eux

# network
sudo systemctl enable NetworkManager.service

# bluetooth
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# sshd
sudo systemctl enable sshd

# gui
sudo systemctl enable lightdm.service
cp -pi /etc/X11/xinit/xinitrc /home/${USER}/.xinitrc
libinput-gestures-setup autostart

# docker
sudo systemctl enable docker
sudo usermod -aG docker ${USER}

# asdf
source /opt/asdf-vm/asdf.sh
asdf plugin add kubectl

# additional-settings
localectl --no-convert set-x11-keymap us pc104  ctrl:nocaps

