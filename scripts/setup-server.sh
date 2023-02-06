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

# static ip
sudo nmcli connection add con-name wired-static type ethernet
sudo nmcli connection modify wired-static ipv4.addresses 192.168.2.15/24
sudo nmcli connection modify wired-static ipv4.gateway 192.168.2.1
sudo nmcli connection modify wired-static ipv4.dns 8.8.8.8
sudo nmcli connection modify wired-static +ipv4.dns 192.168.2.1
sudo nmcli connection modify wired-static ipv4.method manual
sudo nmcli connection modify wired-static ifname eno1
sudo nmcli connection up wired-static

