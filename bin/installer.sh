#!/bin/bash
set -euo pipefail

declare option_vim7=no

function usage_exit() {
  echo "usage: $0 [options...]"
  echo ""
  echo "options:"
  echo "  --vim7: use vim7"
  exit 1
}

# https://stackoverflow.com/questions/3915040
function abspath() {
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

function echo_repo_dir() {
  echo $(abspath $(dirname $0)/..)
}

function echo_src_dir() {
  echo $(echo_repo_dir)/src
}

main() {
  # ローカルリポジトリのパスを得る
  local src_dir=$(echo_src_dir)

  # なければディレクトリを作る
  mkdir -pv $HOME/.config
  mkdir -m 0700 -pv $HOME/.ssh

  # ファイルのシンボリックリンクを上書きで作る
  ln -fsv $src_dir/dot.bashrc_local.sh $HOME/.bashrc_local.sh
  ln -fsv $src_dir/dot.ctags $HOME/.ctags
  ln -fsv $src_dir/dot.editorconfig $HOME/.editorconfig
  ln -fsv $src_dir/dot.gitconfig $HOME/.gitconfig
  ln -fsv $src_dir/dot.gvimrc $HOME/.gvimrc
  ln -fsv $src_dir/dot.inputrc $HOME/.inputrc
  ln -fsv $src_dir/dot.tmux.conf $HOME/.tmux.conf
  ln -fsv $src_dir/dot.vimrc $HOME/.vimrc

  # ディレクトリのシンボリックリンクを上書きで作る
  ln -fnsv $src_dir/dot.config/nvim $HOME/.config/nvim
  ln -fnsv $src_dir/dot.vim $HOME/.vim
  ln -fnsv $src_dir/dot.bashrc.d $HOME/.bashrc.d

  # なければコピーする
  cp -nv $src_dir/dot.gitconfig_local.inc \
    $HOME/.gitconfig_local.inc

  # なければリンクする
  if [[ -f $HOME/.ssh/config ]]; then
    ln -nsv $src_dir/dot.ssh/config $HOME/.ssh/config
  fi

  # $HOME/.bashrc_local.sh を読むようにする
  line='source $HOME/.bashrc_local.sh'
  if ! grep -Fq "$line" $HOME/.bashrc; then
    cp -afv $HOME/.bashrc{,-$(date '+%F.%s')}
    ( echo ""; echo "$line" ) | tee -a $HOME/.bashrc >/dev/null
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
}

while getopts -- "-:h" opt; do
  case $opt in
    -)
      case $OPTARG in
        vim7) option_vim7=yes;;
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

main

# vim:ts=2 sw=2 sts=2 et ai:
