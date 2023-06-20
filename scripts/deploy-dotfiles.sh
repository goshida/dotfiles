#!/usr/bin/env bash

set -eux

_DOTFILES_ROOT=$( cd $( dirname $0 )/../ && pwd )

ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.bash_profile ~/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.bashrc ~/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.profile ~/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.xprofile ~/

mkdir -p ~/.config
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/nvim ~/.config/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/screen ~/.config/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/git ~/.config/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/starship ~/.config/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/xfce4 ~/.config/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/fcitx ~/.config/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/plank ~/.config/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/libinput-gestures.conf ~/.config/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/locale.conf ~/.config/

sudo gpasswd -a ${USER} input

mkdir -p ~/.config/autostart
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/autostart/Plank.desktop ~/.config/autostart/
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.config/autostart/libinput-gestures.desktop ~/.config/autostart/

mkdir -p ~/.local/bin
for _COMMAND in `ls -1 ${_DOTFILES_ROOT}/bin/`; do
  ln -sfn ${_DOTFILES_ROOT}/bin/${_COMMAND} ~/.local/bin/
done

mkdir -p ~/.local/share
ln --backup=simple -sn ${_DOTFILES_ROOT}/home/.local/share/resources ~/.local/share/

