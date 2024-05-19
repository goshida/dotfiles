#!/usr/bin/env bash

# archive secret files
#   e.g. SSH keys, AWS CLI config, ...
#
# Usage
#   ./archive-secrets.sh

set -eux

dotfiles_root=$( cd $( dirname $0 )/../ && pwd )


# ----- import utilities

echo-log() {
  ${dotfiles_root}/scripts/util/echo-log.sh $@
}


# ----- main

date="$( date '+%Y%m%d-%H%M%S' )"
working_dir="${dotfiles_root}/tmp"
archive_dir="secrets-${date}"

if [ -d ${working_dir}/${archive_dir} ] || [ -f ${working_dir}/${archive_dir}.tar.gz ]; then
  echo-log error "${working_dir}/${archive_dir} or ${working_dir}/${archive_dir}.tar.gz is exist. try again."
  exit 1
fi

echo-log info 'start archiving secret files.'


echo-log info 'copying secret files for archive.'

mkdir ${working_dir}/${archive_dir}

echo-log info 'copying SSH files.'
mkdir ${working_dir}/${archive_dir}/ssh
cp -pr ~/.ssh/* ${working_dir}/${archive_dir}/ssh/
echo-log info 'copied SSH files'

echo-log info 'exporting GPG data.'
mkdir ${working_dir}/${archive_dir}/gpg
gpg --export -a --output ${working_dir}/${archive_dir}/gpg/public-keys.asc
gpg --export-secret-keys --output ${working_dir}/${archive_dir}/gpg/secret-keys.asc
if [ -f ${working_dir}/${archive_dir}/gpg/secret-keys.asc ] ; then
  chmod 600 ${working_dir}/${archive_dir}/gpg/secret-keys.asc
fi
if gpg --export-ownertrust --output ${working_dir}/${archive_dir}/gpg/ownertrust ; then
  chmod 600 ${working_dir}/${archive_dir}/gpg/ownertrust
fi
if [ $( ls -1 ${working_dir}/${archive_dir}/gpg | wc -l) -gt 0 ]; then
  echo-log info 'exported GPG data.'
else
  echo-log warn 'no data to export, archive does not contain GPG data.'
  rmdir ${working_dir}/${archive_dir}/gpg
fi

echo-log info 'copying Git files.'
if [ -f ~/.config/git/config ] ;then
  mkdir ${working_dir}/${archive_dir}/git
  cp -pr ~/.config/git/config ${working_dir}/${archive_dir}/git
  echo-log info 'copied Git files.'
else
  echo-log warn 'Git files not found, skipped copying.'
fi

echo-log info 'copying AWS CLI files.'
if [ -f ~/.aws/config ]; then
  mkdir ${working_dir}/${archive_dir}/aws
  cp -p ~/.aws/config ${working_dir}/${archive_dir}/aws/
  echo-log info 'copied AWS CLI files.'
else
  echo-log warn 'AWS CLI files not found, skipped copying.'
fi

echo-log ok 'copied secret files for archive.'


echo-log info 'archive the following files.'
find ${working_dir}/${archive_dir}

echo-log info 'archiving secret files.'
tar -C ${working_dir} -zcvf ${working_dir}/${archive_dir}.tar.gz ${archive_dir}
echo-log info 'archived secret files.'


echo-log info 'delete copied secret files.'
rm -rf ${working_dir}/${archive_dir}
echo-log info 'deleted copied secret files.'


echo-log ok "secret files archived to ${working_dir}/${archive_dir}.tar.gz"
echo-log notice 'do not forget to delete it after use.'

