#!/bin/bash
set -euo pipefail

function usage_exit() {
  echo "usage: $0 [options...]"
  echo ""
  echo "options:"
  echo "  -h, --help: display this help and exit"
  exit 1
}

function echo_err() {
  echo "$1" 1>&2
}

function echo_err_badopt() {
  local optarg="$1"
  echo_err "$0: illegal option -- $optarg"
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
  if type tmux 2>&1 >>/dev/null; then
    tmux -V \
      | while read -r tmux version; do
          if echo $version | grep -q '^1'; then
            ln -fsv $src_dir/dot.tmux.conf.lt_v2.1 $HOME/.tmux.conf
          elif echo $version | grep -q '^2\.0'; then
            ln -fsv $src_dir/dot.tmux.conf.lt_v2.1 $HOME/.tmux.conf
          else
            ln -fsv $src_dir/dot.tmux.conf.ge_v2.1 $HOME/.tmux.conf
          fi
        done
  fi
  ln -fsv $src_dir/dot.tmux.conf.all $HOME/.tmux.conf.all
  ln -fsv $src_dir/dot.vimrc $HOME/.vimrc

  # ディレクトリのシンボリックリンクを上書きで作る
  ln -fnsv $src_dir/dot.config/nvim $HOME/.config/nvim
  ln -fnsv $src_dir/dot.vim $HOME/.vim
  ln -fnsv $src_dir/dot.bashrc.d $HOME/.bashrc.d

  # なければコピーする
  cp -nv $src_dir/dot.gitconfig_local.inc \
    $HOME/.gitconfig_local.inc || true

  # なければリンクする
  if [[ -f $HOME/.ssh/config ]]; then
    ln -nsv $src_dir/dot.ssh/config $HOME/.ssh/config
  fi

  # $HOME/.bashrc_local.sh を読むようにする
  if [[ ! -f $HOME/.bash_profile ]]; then
    (
      echo "#!bash"
      echo 'if [[ -f ~/.bashrc ]]; then'
      echo '  source ~/.bashrc'
      echo 'fi'
    ) | tee $HOME/.bash_profile
  fi
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

main

# vim:ts=2 sw=2 sts=2 et ai:
