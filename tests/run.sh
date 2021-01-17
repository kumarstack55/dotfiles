#!/bin/bash

set -u

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

# shellcheck disable=SC2164
cd "$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)/.."

ensure nvim '+Vader! tests/vader/*.vader'
ensure bats tests/bats

#txt_file=$(my_mktemp -h find)
#
#find "$script_dir" -type f -executable -name "test_*.sh" \
#  >"$txt_file"
#
#for test_path in $(cat "$txt_file"); do
#  echo "test_path: $test_path"
#  timeout 10s $test_path
#done

echo "ok"
