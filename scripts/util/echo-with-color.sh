#!/usr/bin/env bash
set -Ceu


# utility for dotfiles scripts
# Usage
#   echo-with-color.sh <COLOR> <MESSAGE>

case $1 in
  black)
    color_code='\e[30m'
    ;;
  red)
    color_code='\e[31m'
    ;;
  green)
    color_code='\e[32m'
    ;;
  yellow)
    color_code='\e[33m'
    ;;
  blue)
    color_code='\e[34m'
    ;;
  magenta)
    color_code='\e[35m'
    ;;
  cyan)
    color_code='\e[36m'
    ;;
  white)
    color_code='\e[37m'
    ;;
  *)
    echo "color: $1 is unimplemented."
    exit 1
    ;;
esac
shift

printf "${color_code}"
printf "$@"
printf '\e[m'

