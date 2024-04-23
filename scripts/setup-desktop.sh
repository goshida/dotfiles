#!/usr/bin/env bash

# system configuration script for desktop
#
# Usage
#   ./setup-desktop.sh

set -eux

dotfiles_root=$( cd $( dirname $0 )/../ && pwd )


# ----- import utilities

echo-log() {
  ${dotfiles_root}/scripts/util/echo-log.sh $@
}


# ----- main

setup_date="$( date '+%Y%m%d-%H%M%S' )"

echo-log info 'start system configuration for desktop.'


echo-log info 'configure pacman.'
sudo cp -p /etc/pacman.conf /etc/pacman.conf.${setup_date}
sudo install -o root -g root -m 644 -D ${dotfiles_root}/etc/pacman.conf /etc/pacman.conf
echo-log info 'configured pacman.'

echo-log info 'configure sudo.'
sudo cp -p /etc/sudoers /etc/sudoers.${setup_date}
sudo sh -c "cat ${dotfiles_root}/etc/sudoers | EDITOR=tee visudo"
echo-log info 'configured sudo.'

echo-log info 'configure nftables.'
if [ -f /usr/lib/systemd/system/nftables.service ]; then
  sudo cp -p /etc/nftables.conf /etc/nftables.conf.${setup_date}
  sudo install -o root -g root -m 644 -D ${dotfiles_root}/etc/nftables.conf /etc/nftables.conf
  sudo systemctl enable nftables.service
  echo-log info 'configured firewall.'
else
  echo-log warn 'nftables not found, skipped configuration.'
fi

echo-log info 'configure LightDM.'
if [ -f /usr/lib/systemd/system/lightdm.service ]; then
  cp --backup=simple -p /etc/X11/xinit/xinitrc /home/${USER}/.xinitrc
  sudo systemctl enable lightdm.service
  libinput-gestures-setup autostart
  echo-log info 'configured LightDM.'
else
  echo-log warm 'LightDM not found, skipped configuration.'
fi

echo-log info 'configure bluetooth service.'
if [ -f /usr/lib/systemd/system/bluetooth.service ]; then
  sudo systemctl enable bluetooth
  echo-log info 'configured bluetooth service.'
else
  echo-log warn 'bluetooth service not found, skipped enabling.'
fi

echo-log info 'configure docker service.'
if [ -f /usr/lib/systemd/system/docker.service ]; then
  sudo systemctl enable docker
  echo-log info 'configure docker service.'
else
  echo-log warn 'docker service not found, skipped enabling.'
fi

echo-log info 'configure keymap. ( kill CapsLock )'
sudo localectl --no-convert set-x11-keymap us pc104 "" ctrl:nocaps
echo-log info 'configured keymap. ( kill CapsLock )'


echo-log ok 'complete system configuration for desktop.'

