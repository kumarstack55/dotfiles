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

executable() {
  type "$1" >/dev/null 2>&1
}

main() {
  local opt
  while getopts -- "-:h" opt; do
    case $opt in
      h)  usage_exit;;
      \?) usage_exit;;
    esac
  done
  shift $((OPTIND-1))

  cd $HOME

  if ! executable git; then
    err "git: command not found."
    exit 1
  fi

  if [ ! -d dotfiles ]; then
    git clone git@github.com:kumarstack55/dotfiles.git
    if [[ $? -ne 0 ]]; then
      git clone https://github.com/kumarstack55/dotfiles.git
    fi
  fi

  cd $HOME/dotfiles/bin
  ./installer.sh
}

main "$@"
