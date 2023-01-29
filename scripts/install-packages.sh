#!/usr/bin/env bash

set -eux

_DOTFILES_ROOT=$( cd $( dirname $0 )/../ && pwd )
_PROFILE=${1}

if type yay > /dev/null 2>&1 ; then
  yay -S $( grep -h -v -e '^#' -e '^$' ${_DOTFILES_ROOT}/packagelist/${_PROFILE} | tr '\n' ' ' )
else
  sudo pacman -S $( grep -h -v -e '^#' -e '^$' ${_DOTFILES_ROOT}/packagelist/${_PROFILE} | tr '\n' ' ' )
fi

