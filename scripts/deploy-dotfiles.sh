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


# ----- functions

create-link() {
  if [ "$1" != '/*' ]; then
    link_target="$(cd $(dirname $1) && pwd)/$(basename $1)"
  else
    link_target="$1"
  fi

  if [ -d "$2" ]; then
    link_source="${2%/}/$(basename ${link_target})"
  else
    link_source="$2"
  fi

  echo-log info "create symbolic link : ${link_source} ."
  if [ -L "${link_source}" ] && [ "$(readlink ${link_source})" = "${link_target}" ]; then
    echo-log info "symbolic link with the same target already exist; creation skipped."
  elif [ -e "${link_source}" ]; then
    echo-log info "the file already exists. backup it and create symbolic link."
    ln --backup=simple -sn ${link_target} ${link_source}
    ls -ld ${link_source}*
  else
    ln --backup=simple -sn ${link_target} ${link_source}
    ls -ld ${link_source}*
  fi
}

# ----- main

echo-log info 'start dotfiles deployment.'

echo-log info 'deploying ~/ files.'
create-link ${dotfiles_root}/home/.bash_profile ~/
create-link ${dotfiles_root}/home/.bashrc ~/
create-link ${dotfiles_root}/home/.profile ~/
create-link ${dotfiles_root}/home/.xprofile ~/
mkdir -p ~/.gnupg
create-link ${dotfiles_root}/home/.gnupg/gpg.conf ~/.gnupg/
create-link ${dotfiles_root}/home/.gnupg/gpg-agent.conf ~/.gnupg/
echo-log info 'deployed ~/ files.'

echo-log info 'deploying ~/.config/ files.'
mkdir -p ~/.config
create-link ${dotfiles_root}/home/.config/fcitx5 ~/.config/
create-link ${dotfiles_root}/home/.config/nvim ~/.config/
create-link ${dotfiles_root}/home/.config/screen ~/.config/
create-link ${dotfiles_root}/home/.config/starship ~/.config/
create-link ${dotfiles_root}/home/.config/mise ~/.config/
create-link ${dotfiles_root}/home/.config/alacritty ~/.config/
create-link ${dotfiles_root}/home/.config/sway ~/.config/
create-link ${dotfiles_root}/home/.config/swaylock ~/.config/
create-link ${dotfiles_root}/home/.config/waybar ~/.config/
create-link ${dotfiles_root}/home/.config/mako ~/.config/
create-link ${dotfiles_root}/home/.config/xfce4 ~/.config/
create-link ${dotfiles_root}/home/.config/plank ~/.config/
create-link ${dotfiles_root}/home/.config/fontconfig ~/.config/
create-link ${dotfiles_root}/home/.config/libinput-gestures.conf ~/.config/
create-link ${dotfiles_root}/home/.config/locale.conf ~/.config/
create-link ${dotfiles_root}/home/.config/mimeapps.list ~/.config/
mkdir -p ~/.config/autostart
create-link ${dotfiles_root}/home/.config/autostart/Plank.desktop ~/.config/autostart/
create-link ${dotfiles_root}/home/.config/autostart/libinput-gestures.desktop ~/.config/autostart/
echo-log info 'deplyed ~/.config/ files.'

echo-log info 'setting user groups.'
for group in input docker ; do
  if grep -q "^${group}:" /etc/group ; then
    if groups ${USER} | grep -q "\b${group}\b" ; then
      echo-log info "user alread exist in ${group} group, skipped adding user.."
    else
      sudo gpasswd --add ${USER} ${group}
      echo-log info "user added to ${group} group."
    fi
  else
    echo-log warn "${group} is not found, skipped adding user."
  fi
done
echo-log info 'set user groups.'

echo-log info 'creating links to executable files in ~/.local/bin/ .'
mkdir -p ~/.local/bin
for executable_file in `ls -1 ${dotfiles_root}/home/.local/bin/`; do
  create-link ${dotfiles_root}/home/.local/bin/${executable_file} ~/.local/bin/
done
echo-log info 'created links to executable files in ~/.local/bin/ .'

echo-log info 'deploying resource files to ~/.local/share/ .'
mkdir -p ~/.local/share
create-link ${dotfiles_root}/home/.local/share/resources ~/.local/share/
echo-log info 'deployed resource files to ~/.local/share/ .'


echo-log ok 'complete dotfiles deployment.'

