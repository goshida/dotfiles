#!/usr/bin/env bash

# archive secret files
#   e.g. SSH keys, AWS CLI config, ...
#
# Usage
#   ./archive-secrets.sh

set -Ceux

dotfiles_root=$( cd $( dirname $0 )/../ && pwd )


# ----- import utilities

echo-log() {
  ${dotfiles_root}/scripts/util/echo-log.sh $@
}


# ----- main

date="$(date '+%Y%m%d-%H%M%S')"
working_dir='/tmp'
archive_dir="secrets-${date}"

if [ -d ${working_dir}/${archive_dir} ] || [ -f ${working_dir}/${archive_dir}.tar.gz ]; then
  echo-log error "${working_dir}/${archive_dir} or ${working_dir}/${archive_dir}.tar.gz is exist. try again."
fi


echo-log info 'copying secret files for archive.'

mkdir ${working_dir}/${archive_dir}

echo-log info 'copying SSH files.'
mkdir ${working_dir}/${archive_dir}/ssh
cp -pr ~/.ssh/* ${working_dir}/${archive_dir}/ssh/
echo-log info 'copied SSH files'

echo-log info 'exporting GPG data.'
mkdir ${working_dir}/${archive_dir}/gpg
gpg --export -a > ${working_dir}/${archive_dir}/gpg/public-keys.asc
gpg --export-secret-keys -a > ${working_dir}/${archive_dir}/gpg/secret-keys.asc
chmod 600 ${working_dir}/${archive_dir}/gpg/secret-keys.asc
gpg --export-ownertrust > ${working_dir}/${archive_dir}/gpg/ownertrust
chmod 600 ${working_dir}/${archive_dir}/gpg/ownertrust
echo-log info 'exported GPG data.'

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
tree ${working_dir}/${archive_dir}

echo-log info 'archiving secret files.'
tar -C ${working_dir} -zcvf ${working_dir}/${archive_dir}.tar.gz ${archive_dir}
echo-log info 'archived secret files.'


echo-log info 'delete copied secret files.'
rm -rf ${working_dir}/${archive_dir}
echo-log info 'deleted copied secret files.'


echo-log ok "secret files archived to ${working_dir}/${archive_dir}"
echo-log notice 'do not forget to delete it after use.'

