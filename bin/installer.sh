#!/bin/bash

what_if=

usage_exit() {
  err "usage: $0 [options...]"
  err ""
  err "optional arguments"
  err "  -f  disable dry-run mode"
  err "  -c  enable dry-run mode"
  err "  -h  show this help message and exit"
  exit 1
}

err() {
  echo "$1" 1>&2
}

should_process() {
  local op="$1" target="$2"
  if [[ "${what_if:+x}" ]]; then
    echo "WhatIf: The operation '$op' is executed on the target '$target'."
    return 1
  fi
  return 0
}

is_mingw() {
  [ "$(uname -o)" == "Msys" ]
}

is_unix() {
  return 0
}

is_windows() {
  return 1
}

executable() {
  type "$1" >/dev/null 2>&1
}

tmux_ver_int() {
  local ver_str major minor
  ver_str=$(tmux -V | cut -d' ' -f2)
  major=$(echo "$ver_str" | cut -d. -f 1)
  minor=$(echo "$ver_str" | cut -d. -f 2 | grep -Po '\d+')
  printf "%d%02d" "$major" "$minor"
}

tmux_version_lt_2pt1() {
  executable tmux && [[ $(tmux_ver_int) -lt 201 ]]
}

tmux_version_ge_2pt1() {
  executable tmux && [[ $(tmux_ver_int) -ge 201 ]]
}

module_symlink() {
  local src="$1" path="$2"
  local target
  if [ ! -e "$src" ]; then
    echo "No such file or directory: $src"
    return 1
  fi
  target=$(readlink -f "$src")
  if should_process "make symlink" "$target --> $path"; then
    ln -fnsv "$target" "$path"
  fi
}

module_directory() {
  local path="$1" mode="$2"
  if should_process "mkdir" "$path"; then
    mkdir -pv "$path"
  fi
  if [ "${mode:+x}" ]; then
    if should_process "chmod" "mode: $mode, path: $path"; then
      chmod -v "$mode" "$path"
    fi
  fi
}

module_copy() {
  local src="$1" path="$2" force="$3"
  exists=$(test -e "$path" && echo 'y')
  if [ ! "${exists:+x}" ]; then
    if should_process "copy" "$src to $path"; then
      cp -av "$src" "$path"
    fi
  elif [ "${exists:+x}" ] && [ "${force:+x}" ]; then
    if should_process "copy" "$src to $path"; then
      cp -afv "$src" "$path"
    fi
  fi
}

module_touch() {
  local path="$1"
  if should_process "touch" "$path"; then
    touch "$path"
  fi
}

module_lineinfile() {
  local path="$1" line="$2"
  if [ -f "$path" ]; then
    if ! grep -Fq "$line" "$path"; then
      if should_process "make backup" "$path"; then
        cp -afv "$path"{,"-$(date "+%F.%s")"}
      fi
      if should_process "append" "line: $line, path: $path"; then
        { echo ""; echo "$line"; } | tee -a "$path" >/dev/null
      fi
    fi
  fi
}

module_get_url() {
  local url="$1" path="$2"

  if [ ! -f "$path" ]; then
    if should_process "write file" "$path"; then
      curl -Lo "$path" "$url"
    fi
  fi
}

echo_ok() {
  tput setaf 2
  echo 'ok'
  tput sgr0
}

echo_skipping() {
  tput setaf 3
  echo 'skipping'
  tput sgr0
}

echo_failed() {
  tput setaf 1
  echo 'failed'
  tput sgr0
}

execute_tasks() {

  echo "# TASK [Ensure that XDG_CONFIG_HOME directory exists]"
  echo "# ************************************************************"
  if true; then
    module_directory '.config' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that .vimrc is configured]"
  echo "# ************************************************************"
  if ! is_mingw; then
    module_symlink 'dotfiles/src/dot.vimrc' '.vimrc' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that _vimrc is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.vimrc' '_vimrc' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that .vim directory is configured]"
  echo "# ************************************************************"
  if ! is_mingw; then
    module_symlink 'dotfiles/src/dot.vim' '.vim' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that .gvimrc is configured]"
  echo "# ************************************************************"
  if ( ! is_mingw ) && ( is_unix ); then
    module_symlink 'dotfiles/src/dot.gvimrc' '.gvimrc' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that _gvimrc is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.gvimrc' '_gvimrc' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that AppData/Local/nvim is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/AppData/Local/nvim' 'AppData/Local/nvim' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that .config/nvim is configured]"
  echo "# ************************************************************"
  if ! is_mingw; then
    module_symlink 'dotfiles/src/dot.config/nvim' '.config/nvim' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that .vim/autoload directory exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_directory '.vim/autoload' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that .vim/autoload/plug.vim exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_get_url 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' '.vim/autoload/plug.vim' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [NeoVim | Ensure that .local/share/nvim/site/autoload directory exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_directory '.local/share/nvim/site/autoload' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [NeoVim | Ensure that .local/share/nvim/site/autoload/plug.vim exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_get_url 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' '.local/share/nvim/site/autoload/plug.vim' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that vimfiles directory is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.vim' 'vimfiles' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that vimfiles/autoload/plug.vim for Vim exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_get_url 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 'vimfiles/autoload/plug.vim' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Windows | Ensure that AppData/Local/nvim/autoload directory exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_directory 'AppData/Local/nvim/autoload' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Vim | Ensure that plug.vim for NeoVim exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_get_url 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 'AppData/Local/nvim/autoload/plug.vim' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Visual Studio | VsVim | Ensure that .vsvimrc is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.vsvimrc' '.vsvimrc' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Git | Ensure that .gitconfig is configured]"
  echo "# ************************************************************"
  if ! is_mingw; then
    module_symlink 'dotfiles/src/dot.gitconfig' '.gitconfig' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Git | Ensure that .gitconfig_local.inc is configured]"
  echo "# ************************************************************"
  if true; then
    module_copy 'dotfiles/src/dot.gitconfig_local.inc' '.gitconfig_local.inc' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Git | Ensure that .gitconfig_windows.inc is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.gitconfig_windows.inc' '.gitconfig_windows.inc' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Git | Ensure that .gitconfig_profiles.json.sample is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.gitconfig_profiles.json.sample' '.gitconfig_profiles.json.sample' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [GitHub | Ensure that .config/gh directory is configured]"
  echo "# ************************************************************"
  if ! is_mingw; then
    module_symlink 'dotfiles/src/dot.config/gh' '.config/gh' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Commitizen | Ensure that .czrc is configured]"
  echo "# ************************************************************"
  if ! is_mingw; then
    module_symlink 'dotfiles/src/dot.czrc' '.czrc' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Mercurial | Ensure that .hgrc is configured]"
  echo "# ************************************************************"
  if ! is_mingw; then
    module_symlink 'dotfiles/src/dot.hgrc' '.hgrc' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Mercurial | Ensure that .hgrc_local.ini is configured]"
  echo "# ************************************************************"
  if true; then
    module_copy 'dotfiles/src/dot.hgrc_local.ini' '.hgrc_local.ini' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Ansible | Ensure that .ansible.cfg is configured]"
  echo "# ************************************************************"
  if ( ! is_mingw ) && ( is_unix ); then
    module_symlink 'dotfiles/src/dot.ansible.cfg' '.ansible.cfg' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Python | Ensure that pip directory is configured]"
  echo "# ************************************************************"
  if ( ! is_mingw ) && ( is_unix ); then
    module_symlink 'dotfiles/src/dot.config/pip' '.config/pip' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [OpenSSH | Ensure that ssh directory exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_directory '.ssh' '0700' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Universal Ctags | Ensure that .ctags.d directory exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.ctags.d' '.ctags.d' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Universal Ctags | Ensure that ctags.d directory exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.ctags.d' 'ctags.d' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [EditorConfig | Ensure that .editorconfig is configured]"
  echo "# ************************************************************"
  if ! is_mingw; then
    module_symlink 'dotfiles/src/dot.editorconfig' '.editorconfig' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [tmux | Ensure that .tmux.conf is configured (version < v2.1)]"
  echo "# ************************************************************"
  if ( is_unix ) && ( ! is_mingw ) && ( tmux_version_lt_2pt1 ); then
    module_symlink 'dotfiles/src/dot.tmux.conf.lt_v2.1' '.tmux.conf' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [tmux | Ensure that .tmux.conf is configured (version >= v2.1)]"
  echo "# ************************************************************"
  if ( is_unix ) && ( ! is_mingw ) && ( tmux_version_ge_2pt1 ); then
    module_symlink 'dotfiles/src/dot.tmux.conf.ge_v2.1' '.tmux.conf' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [tmux | Ensure that .tmux.conf.all is configured]"
  echo "# ************************************************************"
  if ( is_unix ) && ( ! is_mingw ); then
    module_symlink 'dotfiles/src/dot.tmux.conf.all' '.tmux.conf.all' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [tmux | Ensure that .tmux directory is configured]"
  echo "# ************************************************************"
  if ( is_unix ) && ( ! is_mingw ); then
    module_symlink 'dotfiles/src/dot.tmux' '.tmux' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Windows Terminal | Ensure that WindowsTerminal directory exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_directory 'AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Windows Terminal | Ensure that WindowsTerminal is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState' 'AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Alacritty | Ensure that AppData/Roaming/alacritty directory is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/AppData/Roaming/alacritty' 'AppData/Roaming/alacritty' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Meld | Ensure that AppData/Local/gtk-3.0 directory exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_directory 'AppData/Local/gtk-3.0' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Meld | Ensure that AppData/Local/gtk-3.0/settings.ini is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/AppData/Local/gtk-3.0/settings.ini' 'AppData/Local/gtk-3.0/settings.ini' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [PowerShell | Ensure that Microsoft.PowerShell_profile.ps1 is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_copy 'dotfiles/src/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1' 'Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [PowerShell | Ensure that Documents/PowerShell directory exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_directory 'Documents/PowerShell' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [PowerShell | Ensure that Microsoft.PowerShell_profile.ps1 is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_copy 'dotfiles/src/Documents/PowerShell/Microsoft.PowerShell_profile.ps1' 'Documents/PowerShell/Microsoft.PowerShell_profile.ps1' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [PowerShell | Ensure that .config/powershell directory is configured]"
  echo "# ************************************************************"
  if ( is_unix ) && ( ! is_mingw ); then
    module_symlink 'dotfiles/src/dot.config/powershell' '.config/powershell' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [PowerShell | Ensure that .powershellrc.ps1 is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.powershellrc.ps1' '.powershellrc.ps1' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [OpenSSH | Ensure that .ssh directory exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_directory '.ssh' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [OpenSSH | Ensure that .ssh/config is configured]"
  echo "# ************************************************************"
  if ( ! is_mingw ) && ( is_unix ); then
    module_symlink 'dotfiles/src/dot.ssh/config' '.ssh/config' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Pageant | Ensure that .ssh/wsl-ssh-pageant directory is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.ssh_windows/wsl-ssh-pageant' '.ssh/wsl-ssh-pageant' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Bash | Ensure that .bashrc.d directory is configured for unix]"
  echo "# ************************************************************"
  if ( ! is_mingw ) && ( is_unix ); then
    module_symlink 'dotfiles/src/dot.bashrc.d' '.bashrc.d' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Bash | Ensure that .bashrc.d directory is configured for mingw by powershell]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.bashrc.d' '.bashrc.d' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Bash | Ensure that .bashrc_local.sh is configured]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.bashrc_local.sh' '.bashrc_local.sh' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Bash | Ensure that .bashrc is configured]"
  echo "# ************************************************************"
  if is_unix; then
    module_touch '.bashrc' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Bash | Ensure that .bashrc_local.sh is configured]"
  echo "# ************************************************************"
  if is_unix; then
    module_lineinfile '.bashrc' 'source $HOME/.bashrc_local.sh' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Bash | Ensure that .bash_profile is configured]"
  echo "# ************************************************************"
  if is_unix; then
    module_copy 'dotfiles/src/dot.bash_profile' '.bash_profile' '' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

  echo "# TASK [Readline | Ensure that .inputrc is configured]"
  echo "# ************************************************************"
  if ( ! is_mingw ) && ( is_unix ); then
    module_symlink 'dotfiles/src/dot.inputrc' '.inputrc' && echo_ok || echo 'failed'
  else
    echo_skipping
  fi
  echo

}

parse_options() {
  local opt
  while getopts cfh opt; do
    case $opt in
      c) what_if=y;;
      f) what_if=;;
      h) usage_exit;;
      \?) usage_exit;;
    esac
  done
  shift $((OPTIND-1))
}

main() {
  parse_options "$@"
  cd "$HOME" || exit 1
  execute_tasks
}

main "$@"
