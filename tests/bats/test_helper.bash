#!/bin/bash

load_funcs() {
  # shellcheck source=../../bin/funcs.sh
  source "$(readlink -f "$BATS_TEST_DIRNAME/../../bin/funcs.sh")"
}

call_func_may_exit() {
  # shellcheck disable=SC2216
  "$@" | true
  return "${PIPESTATUS[0]}"
}
