#!/bin/bash
if type oc >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(oc completion bash)
fi
