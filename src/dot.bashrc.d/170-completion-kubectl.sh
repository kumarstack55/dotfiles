#!/bin/bash
if type kubectl >/dev/null 2>&1; then
  source <(kubectl completion bash)
fi
