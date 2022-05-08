#!/bin/bash

_is_mingw() {
  [[ $(uname -s) =~ ^MINGW64_NT ]]
}

_is_wsl() {
  uname -r | grep -q microsoft
}

if _is_wsl; then
  PATH=$(
    echo "$PATH" \
      | sed -e 's/:/\n/g' \
      | grep -Pv '^\Q/mnt/c/Users/\E[^/]+\Q/.poetry/bin\E$' \
      | paste -sd:
  )
  export PATH
fi

if [[ -d $HOME/.poetry/bin ]]; then
  export PATH="$PATH:$HOME/.poetry/bin"
fi
