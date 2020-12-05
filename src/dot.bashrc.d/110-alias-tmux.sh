#!/bin/bash

# 256色表示を強制する
if type tmux >/dev/null 2>&1; then
  alias tmux='tmux -2'
fi
