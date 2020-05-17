#!/bin/bash
set -euo pipefail

usage_exit() {
  echo "usage: $0 [options...]"
  echo ""
  echo "options:"
  echo "  -h, --help: display this help and exit"
  exit 1
}

echo_err() {
  echo "$1" 1>&2
}

echo_err_badopt() {
  local optarg="$1"
  echo_err "$0: illegal option -- $optarg"
}

abspath() {
  # https://stackoverflow.com/questions/3915040
  # generate absolute path from relative path
  # $1     : relative filename
  # return : absolute path
  if [ -d "$1" ]; then
    # dir
    (cd "$1"; pwd)
  elif [ -f "$1" ]; then
    # file
    if [[ $1 = /* ]]; then
      echo "$1"
    elif [[ $1 == */* ]]; then
      echo "$(cd "${1%/*}"; pwd)/${1##*/}"
    else
      echo "$(pwd)/$1"
    fi
  fi
}

echo_repo_dir() {
  echo $(abspath $(dirname $0)/..)
}

echo_bin_dir() {
  echo $(echo_repo_dir)/bin
}

echo_src_dir() {
  echo $(echo_repo_dir)/src
}

test_item_os() {
  local item_os="$1"
  [[ $item_os == "unix" || $item_os == "any" ]]
}

test_item_when() {
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
  [[ ! -e "$HOME/$item_path" ]]
}

action_symlink() {
  local src_dir=$(echo_src_dir)
  if [[ -d $src_dir/$item_target ]]; then
    ln -fnsv $src_dir/$item_target $HOME/$item_path
  else
    ln -fsv $src_dir/$item_target $HOME/$item_path
  fi
}

action_copy() {
  local src_dir=$(echo_src_dir)
  cp -fv $src_dir/$item_target $HOME/$item_path
}

action_lineinfile() {
  if ! grep -Fq "$item_line" $HOME/$item_path; then
    cp -afv $HOME/$item_path{,-$(date '+%F.%s')}
    ( echo ""; echo "$item_line" ) | tee -a $HOME/$item_path >/dev/null
  fi
}

action_touch() {
  touch $HOME/$item_path
}

action_directory() {
  local options=""
  if [[ ! -z ${item_mode+x} ]]; then
    options="$options -m $item_mode"
  fi
  mkdir $options -pv $HOME/$item_path
}

main() {
  # 引数を解析する
  local opt
  while getopts -- "-:h" opt; do
    case $opt in
      -)
        case $OPTARG in
          help)
            usage_exit;;
          *)
            echo_err_badopt $OPTARG
            usage_exit
            ;;
        esac;;
      h)  usage_exit;;
      \?) usage_exit;;
    esac
  done
  shift $((OPTIND-1))

  # ローカルリポジトリのパスを得る
  local repo_dir=$(echo_repo_dir)
  local src_dir=$(echo_src_dir)
  local bin_dir=$(echo_bin_dir)

  # git-bash で ln はコピーの操作となるが、これをリンク操作にする
  if [[ $(uname -s) =~ ^MINGW64_NT ]]; then
    export MSYS=winsymlinks:nativestrict
  fi

  # インベントリを配置する
  $bin_dir/inventory_to_sh.py $repo_dir/inventory.json \
    | while read -r line; do
        (
          eval "$line"
          test_item_os "$item_os" \
            && test_item_when \
              && action_${item_action} \
                || true
        )
      done

  # Pythonパッケージをインストールする
  if type python3 >/dev/null 2>&1 && type pip3 >/dev/null 2>&1; then
    local req_path="$repo_dir/requirements.txt"
    pip3 install --user -r "$req_path"
  fi

  # vim-plug をインストールする
  if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  if [[ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  if type nvim >/dev/null 2>&1; then
    nvim -u "$HOME/.config/nvim/plugins.vim" -c "try | PlugInstall --sync | finally | qall! | endtry"
  fi
}

main "$@"

# vim:ts=2 sw=2 sts=2 et ai:
