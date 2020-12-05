#!/bin/bash

echo_err() {
  echo "$1" 1>&2
}

ensure() {
  if ! "$@"; then echo_err "command failed: $*"; fi
}

ignore() {
  "$@"
}

echo_err_badopt() {
  local optarg
  optarg="$1"
  echo_err "$0: illegal option -- $optarg"
}

echo_abspath() {
  # https://stackoverflow.com/questions/3915040
  # generate absolute path from relative path
  # $1     : relative filename
  # return : absolute path
  if [ -d "$1" ]; then
    (cd "$1"; pwd)
  elif [ -f "$1" ]; then
    if [[ $1 = /* ]]; then
      echo "$1"
    elif [[ $1 == */* ]]; then
      echo "$(cd "${1%/*}"; pwd)/${1##*/}"
    else
      echo "$(pwd)/$1"
    fi
  fi
}

echo_repo_dir() {
  echo_abspath "$(dirname "$0")/.."
}

echo_bin_dir() {
  echo "$(echo_repo_dir)/bin"
}

echo_src_dir() {
  echo "$(echo_repo_dir)/src"
}

