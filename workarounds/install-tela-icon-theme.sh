#!/usr/bin/env bash

set -eux

dotfiles_root=$( cd $( dirname $0 )/../ && pwd )

# ----- import utilities

echo-log() {
  ${dotfiles_root}/scripts/util/echo-log.sh $@
}


# ----- main

clone_dir="${dotfiles_root}/tmp/clone_dir"


echo-log info "check dependencies"

depend_packages="hicolor-icon-theme gtk-update-icon-cache"

pacman -Q ${depend_packages}


echo-log info 'start install tela-icon-theme ( workaround )'

mkdir -p ${clone_dir}
cd ${clone_dir}

repository_name="Tela-icon-theme"
url="https://github.com/vinceliuice/Tela-icon-theme.git"
version="2024-09-04"
install_dir="/usr/share/icons/"

echo-log info "checkout repository"
git clone "${url}" "${repository_name}"
cd "${repository_name}"
git checkout "${version}"


echo-log info "installing ..."
sed -i '/gtk-update-icon-cache/d' install.sh
sudo ./install.sh -a -d "${install_dir}"

cd ${dotfiles_root}


echo-log info 'clean up temporary files'
rm -rf ${clone_dir}/${repository_name}
rmdir ${clone_dir}


echo-log ok 'complete installation.'

