#!/bin/bash

call_func_may_exit() {
  # shellcheck disable=SC2216
  "$@" | true
  return "${PIPESTATUS[0]}"
}
