#!/bin/bash
if [[ ! $(uname -s) =~ ^MINGW64_NT ]]; then
  case "$TERM" in
    "xterm") TERM=xterm-256color;;
    *) ;;
  esac
  #if [[ -f /etc/os-release ]]; then
  #  if [[ $(source /etc/os-release; echo "$ID") == "debian" ]]; then
  #    TERM=screen-256color
  #    export TERM
  #  fi
  #fi
fi
