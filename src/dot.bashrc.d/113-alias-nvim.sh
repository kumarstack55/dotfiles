#!/bin/bash
if type nvim >/dev/null 2>&1; then
  if [[ $(uname -s) =~ ^MINGW64_NT ]]; then
    alias nvim="winpty nvim"
  else
    alias vim=nvim
  fi
fi
