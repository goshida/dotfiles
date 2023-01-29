#!/usr/bin/env bash

set -eux

_DOTFILES_ROOT=$( cd $( dirname $0 )/../ && pwd )

git clone https://aur.archlinux.org/yay.git ${_DOTFILES_ROOT}/tmp/yay
cd ${_DOTFILES_ROOT}/tmp/yay
makepkg -si
cd ${_DOTFILES_ROOT}
rm -rf ${DOTFILES_ROOT}/tmp/yay

yay --version

