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

pretty_list="${dotfiles_root}/tmp/pretty_list"
core_packages="${dotfiles_root}/tmp/core_packages"
extra_packages="${dotfiles_root}/tmp/extra_packages"
aur_packages="${dotfiles_root}/tmp/aur_packages"

echo-log info 'start package installation.'


echo-log info "target is ${target}"

echo-log info "read package list"

sed -e '/^#/d' -e '/^$/d' -e 's/\s*#.*$//g' ${package_list_file} > ${pretty_list}
grep '^core/' ${pretty_list} > ${core_packages} || true
grep '^extra/' ${pretty_list} > ${extra_packages} || true
grep '^aur/' ${pretty_list} > ${aur_packages} || true

wc -l ${core_packages} ${extra_packages} ${aur_packages}

echo-log info "install the following packages."
cat ${pretty_list}

if type yay > /dev/null ; then
  echo-log info 'install using yay.'
  yay -S $( cat ${core_packages} ${extra_packages} ${aur_packages} | tr '\n' ' ' )
else
  if [ -s ${aur_packages} ]; then
    echo-log warn "skip installation of the following packages because yay command is not found."
    cat ${aur_packages}
  fi
  echo-log info 'install using pacman.'
  sudo pacman -S $( cat ${core_packages} ${extra_packages} | tr '\n' ' ' )
fi

echo-log info 'clean up temporary files'
rm ${pretty_list}
rm ${core_packages}
rm ${extra_packages}
rm ${aur_packages}


echo-log ok 'complete package installation.'

