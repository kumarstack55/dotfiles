#!bash

_ssh_auth_socket_set() {
  local auth_sock_dir="$HOME/.ssh/socks"

  if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    return 0
  fi

  # ソケットへのリンクを作る
  mkdir -pv $auth_sock_dir
  if [[ $SSH_AUTH_SOCK =~ ^/tmp/.*/agent\.[0-9]*$ ]]; then
    local target=$auth_sock_dir/$(basename $SSH_AUTH_SOCK)
    ln -fs $SSH_AUTH_SOCK $target
  fi

  # 無効なリンクを消す
  local symlink
  for symlink in $(find $auth_sock_dir -type l); do
    local sock=$(readlink $symlink)

    local ss
    if [[ -f /bin/ss ]]; then
      # for debian 10, etc.
      ss="/bin/ss"
    elif [[ -f /usr/sbin/ss ]]; then
      # for EL7, etc
      ss="/usr/sbin/ss"
    fi

    if ! $ss -f unix -l | grep LISTEN | grep -F "${sock}" -q; then
      rm -f $symlink
    fi
  done

  # リンクを選ぶ
  local oldest_sock=$(
    find $auth_sock_dir -type l \
    | while read -r symlink; do
        stat -Lc "%Y %n" $symlink
      done \
    | sort -n \
    | head -1 \
    | awk '{print $2}'
  )
  ln -fs $oldest_sock $HOME/.ssh/agent

  # リンクを作る
  export SSH_AUTH_SOCK=$HOME/.ssh/agent
}

_ssh_auth_socket_set
