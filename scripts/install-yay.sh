#!/usr/bin/env bash

# install yay ( AUR helper )
#
# Usage
#   ./install-yay.sh

set -eux

dotfiles_root=$( cd $( dirname $0 )/../ && pwd )

# ----- import utilities

echo-log() {
  ${dotfiles_root}/scripts/util/echo-log.sh $@
}


# ----- main

working_dir="${dotfiles_root}/tmp"

echo-log info 'start yay installation.'


echo-log info 'clone repository.'
cd ${working_dir}
git clone https://aur.archlinux.org/yay.git ${dotfiles_root}/tmp/yay

echo-log info 'build yay.'
cd ${working_dir}/yay
makepkg -si

echo-log info 'clean up temporary files.'
cd ${working_dir}
rm -rf ${working_dir}/yay

echo-log info 'check version.'
yay --version


echo-log ok 'complete yay installation.'

