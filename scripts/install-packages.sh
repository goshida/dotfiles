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
package_list_file="${dotfiles_root}/packages/${target}"
pkgbuild_dir="${dotfiles_root}/packages/pkgbuilds"

pretty_list="${dotfiles_root}/tmp/pretty_list"
core_packages="${dotfiles_root}/tmp/core_packages"
extra_packages="${dotfiles_root}/tmp/extra_packages"
aur_packages="${dotfiles_root}/tmp/aur_packages"
private_packages="${dotfiles_root}/tmp/private_packages"

build_dir="${dotfiles_root}/tmp/build_dir"

echo-log info 'start package installation.'


echo-log info "target is ${target}"

echo-log info "read package list"

sed -e '/^#/d' -e '/^$/d' -e 's/\s*#.*$//g' ${package_list_file} > ${pretty_list}
grep '^core/' ${pretty_list} > ${core_packages} || true
grep '^extra/' ${pretty_list} > ${extra_packages} || true
grep '^aur/' ${pretty_list} > ${aur_packages} || true
grep '^private/' ${pretty_list} > ${private_packages} || true

wc -l ${core_packages} ${extra_packages} ${aur_packages}

echo-log info "install the following packages."
cat ${pretty_list}

if type yay > /dev/null ; then
  echo-log info 'install using yay.'
  if yay -S $( cat ${core_packages} ${extra_packages} ${aur_packages} | tr '\n' ' ' ) ; then
    echo-log info "package installation from core/extra/aur repository was successful."
  else
    echo-log warn "some packages installation failed, check the logs for details."
  fi
else
  if [ -s ${aur_packages} ]; then
    echo-log warn "skip installation of the following packages because yay command is not found."
    cat ${aur_packages}
  fi
  echo-log info 'install using pacman.'
  if sudo pacman -S $( cat ${core_packages} ${extra_packages} | tr '\n' ' ' ) ; then
    echo-log info "package installtion from core/extra repository was successful."
  else
    echo-log warn "some package installation failed, check the logs for details."
  fi
fi

mkdir -p ${build_dir}
if [ -s ${private_packages} ]; then
  echo-log info "install using local PKGBUILD files."
  cd ${build_dir}
  for pkg in $( sed 's/^private\///g' ${private_packages} | tr '\n' ' ' ); do
    echo-log info "install ${pkg} using PKGBUILD"
    cp "${pkgbuild_dir}/${pkg}/PKGBUILD" "${build_dir}"
    makepkg -si
    rm ${build_dir}/*
  done
  cd ${dotfiles_root}
fi

echo-log info 'clean up temporary files'
rm ${pretty_list}
rm ${core_packages}
rm ${extra_packages}
rm ${aur_packages}
rm ${private_packages}
rmdir ${build_dir}


echo-log ok 'complete package installation.'

