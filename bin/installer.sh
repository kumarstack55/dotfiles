#!/bin/bash

what_if=y

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

execute_tasks() {

  echo "# TASK [Ensure that Ansible configured]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.ansible.cfg' '.ansible.cfg' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that XDG_CONFIG_HOME exists]"
  echo "# ************************************************************"
  if true; then
    module_directory '.config' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that config/nvim exists]"
  echo "# ************************************************************"
  if true; then
    module_symlink 'dotfiles/src/dot.config/nvim' '.config/nvim' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that pip configured]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.config/pip' '.config/pip' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that gh configured]"
  echo "# ************************************************************"
  if true; then
    module_symlink 'dotfiles/src/dot.config/gh' '.config/gh' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that ssh exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_directory '.ssh' '0700' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that bashrc_local.sh exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.bashrc_local.sh' '.bashrc_local.sh' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that ctags is configured]"
  echo "# ************************************************************"
  if true; then
    module_symlink 'dotfiles/src/dot.ctags' '.ctags' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that EditorConfig is configured]"
  echo "# ************************************************************"
  if true; then
    module_symlink 'dotfiles/src/dot.editorconfig' '.editorconfig' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that gitconfig exists]"
  echo "# ************************************************************"
  if true; then
    module_symlink 'dotfiles/src/dot.gitconfig' '.gitconfig' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that Commitizen is configured]"
  echo "# ************************************************************"
  if true; then
    module_symlink 'dotfiles/src/dot.czrc' '.czrc' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that Mercurial is configured]"
  echo "# ************************************************************"
  if true; then
    module_symlink 'dotfiles/src/dot.hgrc' '.hgrc' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that gitconfig_windows.inc exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.gitconfig_windows.inc' '.gitconfig_windows.inc' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that gvimrc exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.gvimrc' '.gvimrc' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that gvimrc exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.gvimrc' '_gvimrc' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that inputrc exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.inputrc' '.inputrc' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that tmux.conf exists when version is less than v2.1]"
  echo "# ************************************************************"
  if ( is_unix ) && ( tmux_version_lt_2pt1 ); then
    module_symlink 'dotfiles/src/dot.tmux.conf.lt_v2.1' '.tmux.conf' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that tmux.conf exists when version is equal or greater than v2.1]"
  echo "# ************************************************************"
  if ( is_unix ) && ( tmux_version_ge_2pt1 ); then
    module_symlink 'dotfiles/src/dot.tmux.conf.ge_v2.1' '.tmux.conf' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that tmux.conf.all is configured]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.tmux.conf.all' '.tmux.conf.all' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .tmux directory exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.tmux' '.tmux' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .vimrc exists]"
  echo "# ************************************************************"
  if true; then
    module_symlink 'dotfiles/src/dot.vimrc' '.vimrc' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that nvim is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/AppData/Local/nvim' 'AppData/Local/nvim' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that WindowsTerminal directory exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_directory 'AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that WindowsTerminal is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState' 'AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that gtk directory exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_directory 'AppData/Local/gtk-3.0/' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that gtk is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/AppData/Local/gtk-3.0/settings.ini' 'AppData/Local/gtk-3.0/settings.ini' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that alacritty is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/AppData/Roaming/alacritty' 'AppData/Roaming/alacritty' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .vim exists]"
  echo "# ************************************************************"
  if true; then
    module_symlink 'dotfiles/src/dot.vim' '.vim' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that vimfiles/autoload directory exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_directory 'vimfiles/autoload' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .bashrc.d exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.bashrc.d' '.bashrc.d' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .gitconfig_local.inc exists]"
  echo "# ************************************************************"
  if true; then
    module_copy 'dotfiles/src/dot.gitconfig_local.inc' '.gitconfig_local.inc' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .gitconfig_profiles.json.sample exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.gitconfig_profiles.json.sample' '.gitconfig_profiles.json.sample' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .hgrc_local.inc exists]"
  echo "# ************************************************************"
  if true; then
    module_copy 'dotfiles/src/dot.hgrc_local.ini' '.hgrc_local.ini' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that Microsoft.PowerShell_profile.ps1 exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_copy 'dotfiles/src/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1' 'Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that Documents/PowerShell exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_directory 'Documents/PowerShell' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that PowerShell is configured]"
  echo "# ************************************************************"
  if is_windows; then
    module_copy 'dotfiles/src/Documents/PowerShell/Microsoft.PowerShell_profile.ps1' 'Documents/PowerShell/Microsoft.PowerShell_profile.ps1' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that PowerShell is configured]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.config/powershell' '.config/powershell' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .powershellrc.ps1 exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.powershellrc.ps1' '.powershellrc.ps1' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .ssh exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_directory '.ssh' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .ssh/wsl-ssh-pageant exists]"
  echo "# ************************************************************"
  if is_windows; then
    module_symlink 'dotfiles/src/dot.ssh_windows/wsl-ssh-pageant' '.ssh/wsl-ssh-pageant' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .ssh/config exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_symlink 'dotfiles/src/dot.ssh/config' '.ssh/config' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .bash_profile exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_copy 'dotfiles/src/dot.bash_profile' '.bash_profile' '' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .bashrc exists]"
  echo "# ************************************************************"
  if is_unix; then
    module_touch '.bashrc' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
  fi
  echo

  echo "# TASK [Ensure that .bashrc is configured]"
  echo "# ************************************************************"
  if is_unix; then
    module_lineinfile '.bashrc' 'source $HOME/.bashrc_local.sh' && echo 'ok' || echo 'failed'
  else
    echo "skipping."
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
  execute_tasks
}

main "$@"
