#!/usr/bin/env bash

# deploy secret files from archive
#   e.g. SSH keys, AWS CLI config, ...
#
# - the archive file has been created with archive-secrets.sh
# - the filename of archive file must end with .tar.gz
#
# Usage
#   deploy-secrets.sh <archived-file.tar.gz>

set -Ceux

dotfiles_root=$( cd $( dirname $0 )/../ && pwd )


# ----- import utilities

echo-log() {
  ${dotfiles_root}/scripts/util/echo-log.sh $@
}


# ----- main

if [ $# -ne 1 ]; then
  echo-log error "usage : $0 <archive-file.tar.gz>"
  exit 1
fi

working_dir='/tmp'
archive_file="$1"
extracted_dir="$( basename ${archive_file} .tar.gz )"

echo-log info 'deploy secret files from archive.'


echo-log info 'extracting archive file.'
tar -C ${working_dir} -zxvf ${archive_file}
echo-log info 'extracted archive file.'

echo-log info 'the archived files are below'
tree ${working_dir}/${extracted_dir}


echo-log info 'deploy secret files.'

echo-log info 'deploying SSH files.'
mkdir -p ~/.ssh/
cp -pb ${working_dir}/${extracted_dir}/ssh/* ~/.ssh/
echo-log info 'deployed SSH files.'

echo-log info 'importing GPG data.'
gpg --import ${working_dir}/${extracted_dir}/gpg/public-keys.asc
gpg --import ${working_dir}/${extracted_dir}/gpg/secret-keys.asc
gpg --import ${working_dir}/${extracted_dir}/gpg/ownertrust
echo-log info 'imported GPG data.'

echo-log info 'deploying Git files.'
mkdir -p ~/.config/git/
cp -pb ${working_dir}/${extracted_dir}/git/config ~/.config/git/
echo-log info 'deployed Git files.'

echo-log info 'deploying AWS CLI files.'
if [ -f ${working_dir}/${extracted_dir}/aws/config ]; then
  mkdir -p ~/.aws/
  cp -pb ${working_dir}/${extracted_dir}/aws/config ~/.aws/
  echo-log info 'deployed AWS CLI config'
else
  echo-log warn 'AWS CLI files not found in archive, skipped deploying.'
fi

echo-log ok 'deployed secret files from archive.'


echo-log info 'deleting extracted files.'
rm -rf ${working_dir}/${extracted_dir}
echo-log info 'deleted extracted files.'

echo-log notice 'the archive file : ${archive_file} remains.'
echo-log notice 'delete it manually once deployment is confirmed.'

