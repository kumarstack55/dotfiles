#!/bin/bash
# vim:ts=2 sw=2 sts=2 et ai:

set -euo pipefail

# shellcheck source=funcs.sh
source "$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd -P)/funcs.sh"

usage_exit() {
  echo "usage: $0 [options...]"
  echo ""
  echo "options:"
  echo "  -h, --help: display this help and exit"
  exit 1
}

test_item_os() {
  local item_os
  item_os="$1"
  [[ $item_os == "unix" || $item_os == "any" ]]
}

test_item_when() {
  # shellcheck disable=SC2154
  [ -z "${item_when+x}" ] || eval "when_${item_when}"
}

when_tmux_vesion_lt_2pt1() {
  type tmux >/dev/null 2>&1 \
    && tmux -V \
      | cut -d' ' -f2 \
      | {
          IFS=. read -r major minor
          [[ $major -le 1 || ( ( $major -eq 2 ) && ( $minor -lt 1 ) ) ]]
        }
}

when_tmux_vesion_ge_2pt1() {
  type tmux >/dev/null 2>&1 \
    && tmux -V \
      | cut -d' ' -f2 \
      | {
          IFS=. read -r major minor
          [[ $major -gt 2 || ( ( $major -eq 2 ) && ( $minor -ge 1 ) ) ]]
        }
}

when_path_not_exists() {
  # shellcheck disable=SC2154
  [[ ! -e "$HOME/$item_path" ]]
}

action_symlink() {
  local src_dir
  src_dir=$(echo_src_dir)
  # shellcheck disable=SC2154
  if [[ -d $src_dir/$item_target ]]; then
    ln -fnsv "$src_dir/$item_target" "$HOME/$item_path"
  else
    ln -fsv "$src_dir/$item_target" "$HOME/$item_path"
  fi
}

action_copy() {
  local src_dir
  src_dir=$(echo_src_dir)
  cp -fv "$src_dir/$item_target" "$HOME/$item_path"
}

action_lineinfile() {
  # shellcheck disable=SC2154
  if ! grep -Fq "$item_line" "$HOME/$item_path"; then
    cp -afv "$HOME/$item_path"{,"-$(date "+%F.%s")"}
    ( echo ""; echo "$item_line" ) | tee -a "$HOME/$item_path" >/dev/null
  fi
}

action_touch() {
  touch "$HOME/$item_path"
}

action_directory() {
  # shellcheck disable=SC2154
  if [[ -n ${item_mode+x} ]]; then
    # shellcheck disable=SC2174
    mkdir -m "$item_mode" -pv "$HOME/$item_path"
  else
    mkdir -pv "$HOME/$item_path"
  fi
}

action_chmod_600() {
  chmod 600 "$src_dir/$item_target"
}

main() {
  # 引数を解析する
  local opt
  while getopts -- "-:h" opt; do
    # shellcheck disable=SC2214
    case $opt in
      -)
        case $OPTARG in
          help)
            usage_exit;;
          *)
            echo_err_badopt "$OPTARG"
            usage_exit
            ;;
        esac;;
      h)  usage_exit
      ;;
      \?) usage_exit;;
    esac
  done
  shift $((OPTIND-1))

  # ローカルリポジトリのパスを得る
  local repo_dir src_dir
  repo_dir=$(echo_repo_dir)
  src_dir=$(echo_src_dir)

  # git-bash で ln はコピーの操作となるが、これをリンク操作にする
  if [[ $(uname -s) =~ ^MINGW64_NT ]]; then
    export MSYS=winsymlinks:nativestrict
  fi

  # インベントリを配置する
  while read -r line; do
    (
      item_action="invalid"
      item_os="any"
      eval "$line"

      # shellcheck disable=SC2015
      test_item_os "$item_os" \
        && test_item_when \
          && "action_${item_action}" \
            || true
    )
  done <"$repo_dir/inventory.txt"

  # Pythonパッケージをインストールする
  if type python3 >/dev/null 2>&1 && type pip3 >/dev/null 2>&1; then
    local req_path
    req_path="$repo_dir/requirements.txt"
    ensure pip3 install --user -r "$req_path"
  fi

  # vim-plug をインストールする
  if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    ensure curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  if [[ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]]; then
    ensure curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  if type nvim >/dev/null 2>&1; then
    ensure nvim -u "$HOME/.config/nvim/plugins.vim" \
      -c "try | PlugInstall --sync | finally | qall! | endtry"
  fi
}

main "$@"
