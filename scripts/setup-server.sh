#!/usr/bin/env bash

set -eux

_DOTFILES_ROOT=$( cd $( dirname $0 )/../ && pwd )

_SETUP_TIMESTAMP=`date +%Y%m%d-%H%M%S`

_PUBLIC_IF="eno1"
_WIREGUARD_IF="wg0"

# sudo
sudo cp -p /etc/sudoers /etc/sudoers.${_SETUP_TIMESTAMP}
sudo sh -c "cat ${_DOTFILES_ROOT}/etc/sudoers | EDITOR=tee visudo"

# static ip
sudo nmcli connection add con-name wired-static type ethernet
sudo nmcli connection modify wired-static ipv4.addresses 192.168.2.15/24
sudo nmcli connection modify wired-static ipv4.gateway 192.168.2.1
sudo nmcli connection modify wired-static ipv4.dns 8.8.8.8
sudo nmcli connection modify wired-static +ipv4.dns 192.168.2.1
sudo nmcli connection modify wired-static ipv4.method manual
sudo nmcli connection modify wired-static ifname ${_PUBLIC_IF}
sudo nmcli connection up wired-static

# firewall
sudo cp -p /etc/nftables.conf /etc/nftables.conf.${_SETUP_TIMESTAMP}
sudo install -o root -g root -m 644 -D ${_DOTFILES_ROOT}/etc/nftables.conf /etc/nftables.conf
sudo systemctl enable nftables

# sshd
sudo cp --backup=simple -p /etc/ssh/sshd_config /etc/ssh/sshd_config.${_SETUP_TIMESTAMP}
sudo install -o root -g root -m 644 -D ${_DOTFILES_ROOT}/etc/ssh/sshd_config /etc/ssh/sshd_config
sudo systemctl enable sshd.service
curl https://github.com/goshida.keys >> ~/.ssh/authorized_keys

# WireGuard
sudo nmcli connection add type wireguard con-name wireguard-server ifname ${WIREGUARD_IF} autoconnect no
sudo nmcli connection modify wireguard-server ipv4.method manual ipv4.address 10.0.0.1/24
sudo nmcli connection modify wireguard-server wireguard.private-key `wg genkey`
sudo nmcli connection modify wireguard-server wireguard.listen-port 51820
sudo nmcli connection modify wireguard-server autoconnect yes
sudo sysctl net.ipv4.ip_forward=1
sudo sh -c "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.d/99-sysctl.conf"
sudo install -o root -g root -m 744 -D ${_DOTFILES_ROOT}/etc/NetworkManager/dispatcher.d/wireguard-forward.sh /etc/NetworkManager/dispatcher.d/wireguard-forward.sh
sudo sed -i -e "s/public-if-dummy/${_PUBLIC_IF}/" /etc/NetworkManager/dispatcher.d/wireguard-forward.sh
sudo sed -i -e "s/wireguard-if-dummy/${_WIREGUARD_IF}/" /etc/NetworkManager/dispatcher.d/wireguard-forward.sh
sudo systemctl enable NetworkManager-dispatcher.service

# additional-settings
sudo localectl --no-convert set-x11-keymap us pc104 "" ctrl:nocaps

