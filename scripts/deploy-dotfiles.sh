#!/usr/bin/env bash

# deploy dotfiles
#
# Usage
#   ./deploy-dotfiles.sh

set -eux

dotfiles_root=$( cd $( dirname $0 )/../ && pwd )

# ----- import utilities

echo-log() {
  ${dotfiles_root}/scripts/util/echo-log.sh $@
}


# ----- main

echo-log info 'start dotfiles deployment.'

echo-log info 'deploying ~/ files.'
ln --backup=simple -sn ${dotfiles_root}/home/.bash_profile ~/
ln --backup=simple -sn ${dotfiles_root}/home/.bashrc ~/
ln --backup=simple -sn ${dotfiles_root}/home/.profile ~/
ln --backup=simple -sn ${dotfiles_root}/home/.xprofile ~/
mkdir -p ~/.gnupg
ln --backup=simple -sn ${dotfiles_root}/home/.gnupg/gpg.conf ~/.gnupg/
ln --backup=simple -sn ${dotfiles_root}/home/.gnupg/gpg-agent.conf ~/.gnupg/
echo-log info 'deployed ~/ files.'

echo-log info 'deploying ~/.config/ files.'
mkdir -p ~/.config
ln --backup=simple -sn ${dotfiles_root}/home/.config/fcitx5 ~/.config/
ln --backup=simple -sn ${dotfiles_root}/home/.config/nvim ~/.config/
ln --backup=simple -sn ${dotfiles_root}/home/.config/screen ~/.config/
ln --backup=simple -sn ${dotfiles_root}/home/.config/starship ~/.config/
ln --backup=simple -sn ${dotfiles_root}/home/.config/mise ~/.config/
ln --backup=simple -sn ${dotfiles_root}/home/.config/xfce4 ~/.config/
ln --backup=simple -sn ${dotfiles_root}/home/.config/plank ~/.config/
ln --backup=simple -sn ${dotfiles_root}/home/.config/fontconfig ~/.config/
ln --backup=simple -sn ${dotfiles_root}/home/.config/libinput-gestures.conf ~/.config/
ln --backup=simple -sn ${dotfiles_root}/home/.config/locale.conf ~/.config/
mkdir -p ~/.config/autostart
ln --backup=simple -sn ${dotfiles_root}/home/.config/autostart/Plank.desktop ~/.config/autostart/
ln --backup=simple -sn ${dotfiles_root}/home/.config/autostart/libinput-gestures.desktop ~/.config/autostart/
echo-log info 'deplyed ~/.config/ files.'

echo-log info 'setting user groups.'
for group in input docker ; do
  if grep "^input:" /etc/group ; then
    sudo gpasswd --add ${USER} ${group}
    echo-log info "user added to ${group} group."
  else
    echo-log warn "${group} is not found, skipped adding user."
  fi
done
echo-log info 'set user groups.'

echo-log info 'creating links to executable files in ~/.local/bin/ .'
mkdir -p ~/.local/bin
for _COMMAND in `ls -1 ${dotfiles_root}/home/.local/bin/`; do
  ln -sfn ${dotfiles_root}/home/.local/bin/${_COMMAND} ~/.local/bin/
done
echo-log info 'created links to executable files in ~/.local/bin/ .'

echo-log info 'deploying resource files to ~/.local/share/ .'
mkdir -p ~/.local/share
ln --backup=simple -sn ${dotfiles_root}/home/.local/share/resources ~/.local/share/
echo-log info 'deployed resource files to ~/.local/share/ .'


echo-log ok 'complete dotfiles deployment.'

