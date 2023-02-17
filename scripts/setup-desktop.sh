#!/usr/bin/env bash

set -eux

_DOTFILES_ROOT=$( cd $( dirname $0 )/../ && pwd )

_SETUP_TIMESTAMP=`date +%Y%m%d-%H%M%S`

# sudo
sudo cp -p /etc/sudoers /etc/sudoers.${_SETUP_TIMESTAMP}
sudo sh -c "cat ${_DOTFILES_ROOT}/etc/sudoers | EDITOR=tee visudo"

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

