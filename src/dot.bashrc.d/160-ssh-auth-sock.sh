#!/bin/bash

ssh_auth_sock_export() {
  # 世の中にある tmux 対応のためのソケットリンク処理のいくつかは、
  # 自ホストの自ユーザに ssh するときに、エージェントを破壊する
  # 破壊せずに済むよう、選び方をより賢くする
  # 具体的には過去ソケット群から有効そうな最も古いソケットを選ぶ
  local auth_sock_dir

  auth_sock_dir="$HOME/.ssh/socks"
  mkdir -p "$auth_sock_dir"

  if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    return 0
  fi

  # ソケットのリンクを作る
  if [[ $SSH_AUTH_SOCK =~ ^/tmp/.*/agent\.[0-9]*$ ]]; then
    local target
    target="$auth_sock_dir/$(basename "$SSH_AUTH_SOCK")"
    ln -fs "$SSH_AUTH_SOCK" "$target"
  fi

  # 有効そうでないソケットを消す
  local ss
  if [[ -f /bin/ss ]]; then
    # for debian 10, etc.
    ss="/bin/ss"
  elif [[ -f /usr/sbin/ss ]]; then
    # for EL7, etc
    ss="/usr/sbin/ss"
  fi

  find "$auth_sock_dir" -type l \
  | while read -r symlink; do
      local sock
      sock=$(readlink "$symlink")
      if ! $ss -f unix -l | grep LISTEN | grep -F "${sock}" -q; then
        rm -f "$symlink"
      fi
    done

  # 残ったソケットのうち、最も古いソケットを選ぶ
  local oldest_sock
  oldest_sock=$(
    find "$auth_sock_dir" -type l \
    | while read -r symlink; do stat -Lc "%Y %n" "$symlink"; done \
    | sort -n \
    | head -1 \
    | awk '{print $2}'
  )
  ln -fs "$oldest_sock" "$HOME/.ssh/sock"
  export SSH_AUTH_SOCK="$HOME/.ssh/sock"
}

ssh_auth_sock_export
