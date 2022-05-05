#!/bin/bash

# 既存 python スクリプト動作に影響するためエイリアスを設定しない。
if false; then
  if type python >/dev/null 2>&1; then
    if [[ $(uname -s) =~ ^MINGW64_NT ]]; then
      alias python="winpty python"
    fi
  fi
fi
