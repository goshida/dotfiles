#!/usr/bin/env bash

# system configuration script for server
#
# Usage
#   ./setup-server.sh

set -eux

dotfiles_root=$( cd $( dirname $0 )/../ && pwd )


# ----- import utilities

echo-log() {
  ${dotfiles_root}/scripts/util/echo-log.sh $@
}


# ----- main

setup_date="$( date '+%Y%m%d-%H%M%S' )"
public_if="eno1"
wireguard_if="wg0"

echo-log info 'start system configuration for server.'


echo-log info 'configure sudo.'
sudo cp -p /etc/sudoers /etc/sudoers.${setup_date}
sudo sh -c "cat ${dotfiles_root}/etc/sudoers | EDITOR=tee visudo"
echo-log info 'configured sudo.'

echo-log info 'configure network.'

echo-log info "assume wired connection and the public interface name is ${public_if}."

echo-log info 'configure static address.'
sudo nmcli connection add con-name wired-static type ethernet
sudo nmcli connection modify wired-static ipv4.addresses 192.168.2.15/24
sudo nmcli connection modify wired-static ipv4.gateway 192.168.2.1
sudo nmcli connection modify wired-static ipv4.dns 8.8.8.8
sudo nmcli connection modify wired-static +ipv4.dns 192.168.2.1
sudo nmcli connection modify wired-static ipv4.method manual
sudo nmcli connection modify wired-static ifname ${public_if}
sudo nmcli connection up wired-static
echo-log info 'configure static address.'

echo-log info 'configure nftables.'
if [ -f /usr/lib/systemd/system/nftables.service ]; then
  sudo cp -p /etc/nftables.conf /etc/nftables.conf.${setup_date}
  sudo install -o root -g root -m 644 -D ${dotfiles_root}/etc/nftables.conf /etc/nftables.conf
  sudo systemctl enable nftables.service
  echo-log info 'configured firewall.'
else
  echo-log error 'nftables not found, skipped configuration.'
  exit 0
fi

echo-log info 'configure wireguard.'
echo-log info "wireguard interface name is ${wireguard_if}."
sudo nmcli connection add type wireguard con-name wireguard-server ifname ${wireguard_if} autoconnect no
sudo nmcli connection modify wireguard-server ipv4.method manual ipv4.address 10.0.0.1/24
sudo nmcli connection modify wireguard-server wireguard.private-key `wg genkey`
sudo nmcli connection modify wireguard-server wireguard.listen-port 51820
sudo nmcli connection modify wireguard-server autoconnect yes
sudo sysctl net.ipv4.ip_forward=1
sudo sh -c "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.d/99-sysctl.conf"
sudo install -o root -g root -m 744 -D ${dotfiles_root}/etc/NetworkManager/dispatcher.d/wireguard-forward.sh /etc/NetworkManager/dispatcher.d/wireguard-forward.sh
sudo sed -i -e "s/public-if-dummy/${public_if}/" /etc/NetworkManager/dispatcher.d/wireguard-forward.sh
sudo sed -i -e "s/wireguard-if-dummy/${wireguard_if}/" /etc/NetworkManager/dispatcher.d/wireguard-forward.sh
sudo systemctl enable NetworkManager-dispatcher.service
echo-log info 'configured wireguard.'

echo-log info 'configured network.'

echo-log info 'configure OpenSSH Deamon.'
if [ -f /usr/lib/systemd/system/sshd.service ]; then
  sudo cp --backup=simple -p /etc/ssh/sshd_config /etc/ssh/sshd_config.${setup_date}
  sudo install -o root -g root -m 644 -D ${dotfiles_root}/etc/ssh/sshd_config /etc/ssh/sshd_config
  sudo systemctl enable sshd.service
  curl https://github.com/goshida.keys >> ~/.ssh/authorized_keys
  echo-log info 'configured OpenSSH Deamon.'
else
  echo-log warn 'OpenSSH Deamon is not found, skipped configuration.'
fi

echo-log info 'configure keymap. ( kill CapsLock )'
sudo localectl --no-convert set-x11-keymap us pc104 "" ctrl:nocaps
echo-log info 'configured keymap. ( kill CapsLock )'


echo-log ok 'complete system configuration for server.'

