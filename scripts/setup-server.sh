#!/usr/bin/env bash

set -eux

_DOTFILES_ROOT=$( cd $( dirname $0 )/../ && pwd )

# sshd
sudo systemctl enable sshd.service
curl https://github.com/goshida.keys >> ~/.ssh/authorized_keys
sudo cp -pi /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
sudo cat ${_DOTFILES_ROOT}/etc/ssh/sshd_config > /etc/ssh/sshd_config

# additional-settings
sudo localectl --no-convert set-x11-keymap us pc104 "" ctrl:nocaps

