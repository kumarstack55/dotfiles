#!/bin/bash

echo_err() {
  echo "$1" 1>&2
}

err_exit() {
  echo_err "$1"
  exit 1
}

ensure() {
  if ! "$@"; then err_exit "command failed: $*"; fi
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
  ## shellcheck disable=SC2164
  #echo "$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"
  #return

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
  else
    return 1
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

