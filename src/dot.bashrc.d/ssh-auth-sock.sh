#!bash

_ssh_auth_make_link_in_socks() {
  local auth_sock_dir="$HOME/.ssh/socks"

  if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    return 0
  fi

  mkdir -pv $auth_sock_dir
  if [[ $SSH_AUTH_SOCK =~ ^/tmp/.*/agent\.[0-9]*$ ]]; then
    local target=$auth_sock_dir/$(basename $SSH_AUTH_SOCK)
    ln -fs $SSH_AUTH_SOCK $target
  fi
}

_ssh_auth_cleanup_ss() {
  local auth_sock_dir="$HOME/.ssh/socks"

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
}

_ssh_auth_cleanup_ssh_add() {
  local auth_sock_dir="$HOME/.ssh/socks"

  local opt
  local option_verbose=1
  while getopts -- "v" opt; do
    case $opt in
      v) option_verbose=$(($option_verbose+1));;
    esac
  done
  shift $((OPTIND-1))

  local symlink
  for symlink in $(find $auth_sock_dir -type l); do
    if ! SSH_AUTH_SOCK="$symlink" timeout 0.1 ssh-add -l \
        >/dev/null 2>/dev/null; then
      rm -f $symlink
    fi
  done
}

_ssh_auth_cleanup() {
  # _ssh_auth_cleanup_ss
  _ssh_auth_cleanup_ssh_add
}

_ssh_auth_pick_link() {
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
}

_ssh_auth_socket_set() {
  local auth_sock_dir="$HOME/.ssh/socks"

  _ssh_auth_make_link_in_socks
  _ssh_auth_cleanup
  _ssh_auth_pick_link
  if [[ -f $HOME/.ssh/agent ]]; then
    export SSH_AUTH_SOCK=$HOME/.ssh/agent
  fi
}

_ssh_auth_socket_set
