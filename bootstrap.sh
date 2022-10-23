#!/bin/bash

set -u

usage_exit() {
  echo "usage: $0 [options...]"
  echo ""
  echo "options:"
  echo "  -h, --help: display this help and exit"
  exit 1
}

err() {
  echo "$1" 1>&2
}

err_exit() {
  err "$1"
  exit 1
}

executable() {
  type "$1" >/dev/null 2>&1
}

main() {
  local opt
  while getopts 'h' opt; do
    case $opt in
      h)  usage_exit;;
      \?) usage_exit;;
    esac
  done
  shift $((OPTIND-1))

  cd "$HOME" || err_exit "failed to cd"

  if ! executable git; then
    err "git: command not found."
    exit 1
  fi

  if [ ! -d dotfiles ]; then
    git clone git@github.com:kumarstack55/dotfiles.git
  fi
  if [ ! -d dotfiles ]; then
    git clone https://github.com/kumarstack55/dotfiles.git
  fi

  cd "$HOME" || err_exit "failed to cd"
  dotfiles/bin/installer.sh
}

main "$@"
