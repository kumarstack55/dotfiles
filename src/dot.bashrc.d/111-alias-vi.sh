#!/bin/bash
if type nvim >/dev/null 2>&1; then
  if [[ $(uname -s) =~ ^MINGW64_NT ]]; then
    alias vi="winpty nvim"
  else
    alias vi=nvim
  fi
elif type vim >/dev/null 2>&1; then
  # git-bash などでは Vim が入っているはず。 Vim を winpty 経由で実行しない。
  alias vi=vim
fi
