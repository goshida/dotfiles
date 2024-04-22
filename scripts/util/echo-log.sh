#!/usr/bin/env bash
set -Ceu

# utility for dotfiles script
# Usage
#   echo-log.sh <LOG_LEVEL> <MESSAGE>
#
# LOG_LEVEL
#   INFO
#   ERROR

case $1 in
  error|ERROR)
    log_level='ERROR'
    color='red'
    ;;
  warn|WARN)
    log_level='WARN'
    color='yellow'
    ;;
  notice|NOTICE)
    log_level='NOTICE'
    color='yellow'
    ;;
  info|INFO)
    log_level='INFO'
    color='cyan'
    ;;
  ok|OK)
    log_level='OK'
    color='green'
    ;;
  *)
    echo "log-level: $1 is unimplemented."
    exit 1
    ;;
esac
shift

cd "$(dirname $0)"
./echo-with-color.sh "${color}" "[${log_level}] "
echo "$@"

