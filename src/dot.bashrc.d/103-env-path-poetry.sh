#!/bin/bash
if [[ -d $HOME/.poetry/bin ]]; then
  export PATH="$PATH:$HOME/.poetry/bin"
fi
