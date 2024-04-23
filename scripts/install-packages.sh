#!/usr/bin/env bash

# install packages using pacman/yay
#
# Usage
#   ./install-packages.sh <install-target>

set -eux

dotfiles_root=$( cd $( dirname $0 )/../ && pwd )

# ----- import utilities

echo-log() {
  ${dotfiles_root}/scripts/util/echo-log.sh $@
}


# ----- main

if [ $# -ne 1 ]; then
  echo-log error "usage : $0 <install-target>"
  exit 1
fi

target="${1}"

echo-log info 'start package installation.'


echo-log info "target is ${target}"

echo-log info "install the following packages."
grep -h -v -e '^#' -e '^$' ${dotfiles_root}/packagelist/${target}

if type yay > /dev/null 2>&1 ; then
  echo-log info 'install using yay.'
  yay -S $( grep -h -v -e '^#' -e '^$' ${dotfiles_root}/packagelist/${target} | tr '\n' ' ' )
else
  echo-log info 'install using pacman.'
  sudo pacman -S $( grep -h -v -e '^#' -e '^$' ${dotfiles_root}/packagelist/${target} | tr '\n' ' ' )
fi


echo-log ok 'complete package installation.'

