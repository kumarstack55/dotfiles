#!/bin/bash
if type kubectl 2>&1 >/dev/null; then
  source <(kubectl completion bash)
fi
