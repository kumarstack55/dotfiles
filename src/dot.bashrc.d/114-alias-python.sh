#!/bin/bash
if type python >/dev/null 2>&1; then
  if [[ $(uname -s) =~ ^MINGW64_NT ]]; then
    alias python="winpty python"
  fi
fi
