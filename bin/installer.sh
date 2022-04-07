#!/bin/bash
whatif=y
should_process() {
  local operation="$1" target="$2"
  if [[ "${whatif+x}" ]]; then
    echo "WhatIf: The operation '$operation' is executed on the target '$target'."
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
  if [ ! -f "$src" ]; then
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
  if [ "${mode+x}" ]; then
    if should_process "chmod" "mode: $mode, path: $path"; then
      chmod -v "$mode" "$path"
    fi
  fi
}
module_copy() {
  local src="$1" path="$2" force="$3"
  exists=$(test -e "$path" && echo 'y')
  if [ ! "${exists+x}" ]; then
    if should_process "copy" "$src to $path"; then
      cp -av "$src" "$path"
    fi
  elif [ "${exists+x}" ] && [ "${force+x}" ]; then
    if should_process "copy" "$src to $path"; then
      cp -afv "$src" "$path"
    fi
  fi
}
module_touch() {
  if should_process "touch" "$path"; then
    touch "$1"
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
echo "# TASK [Ensure that Ansible configured]"
if is_unix; then
  module_symlink "dotfiles/src/dot.ansible.cfg" ".ansible.cfg"
fi
echo "# TASK [Ensure that XDG_CONFIG_HOME exists]"
if true; then
  module_directory ".config" ""
fi
echo "# TASK [Ensure that config/nvim exists]"
if true; then
  module_symlink "dotfiles/src/dot.config/nvim" ".config/nvim"
fi
echo "# TASK [Ensure that pip configured]"
if is_unix; then
  module_symlink "dotfiles/src/dot.config/pip" ".config/pip"
fi
echo "# TASK [Ensure that gh configured]"
if true; then
  module_symlink "dotfiles/src/dot.config/gh" ".config/gh"
fi
echo "# TASK [Ensure that ssh exists]"
if is_unix; then
  module_directory ".ssh" "0700"
fi
echo "# TASK [Ensure that bashrc_local.sh exists]"
if is_unix; then
  module_symlink "dotfiles/src/dot.bashrc_local.sh" ".bashrc_local.sh"
fi
echo "# TASK [Ensure that ctags is configured]"
if true; then
  module_symlink "dotfiles/src/dot.ctags" ".ctags"
fi
echo "# TASK [Ensure that EditorConfig is configured]"
if true; then
  module_symlink "dotfiles/src/dot.editorconfig" ".editorconfig"
fi
echo "# TASK [Ensure that gitconfig exists]"
if true; then
  module_symlink "dotfiles/src/dot.gitconfig" ".gitconfig"
fi
echo "# TASK [Ensure that Commitizen is configured]"
if true; then
  module_symlink "dotfiles/src/dot.czrc" ".czrc"
fi
echo "# TASK [Ensure that Mercurial is configured]"
if true; then
  module_symlink "dotfiles/src/dot.hgrc" ".hgrc"
fi
echo "# TASK [Ensure that gitconfig_windows.inc exists]"
if is_windows; then
  module_symlink "dotfiles/src/dot.gitconfig_windows.inc" ".gitconfig_windows.inc"
fi
echo "# TASK [Ensure that gvimrc exists]"
if is_unix; then
  module_symlink "dotfiles/src/dot.gvimrc" ".gvimrc"
fi
echo "# TASK [Ensure that gvimrc exists]"
if is_windows; then
  module_symlink "dotfiles/src/dot.gvimrc" "_gvimrc"
fi
echo "# TASK [Ensure that inputrc exists]"
if is_unix; then
  module_symlink "dotfiles/src/dot.inputrc" ".inputrc"
fi
echo "# TASK [Ensure that tmux.conf exists when version is less than v2.1]"
if ( is_unix ) && ( tmux_version_lt_2pt1 ); then
  module_symlink "dotfiles/src/dot.tmux.conf.lt_v2.1" ".tmux.conf"
fi
echo "# TASK [Ensure that tmux.conf exists when version is equal or greater than v2.1]"
if ( is_unix ) && ( tmux_version_ge_2pt1 ); then
  module_symlink "dotfiles/src/dot.tmux.conf.ge_v2.1" ".tmux.conf"
fi
echo "# TASK [Ensure that tmux.conf.all is configured]"
if is_unix; then
  module_symlink "dotfiles/src/dot.tmux.conf.all" ".tmux.conf.all"
fi
echo "# TASK [Ensure that .tmux directory exists]"
if is_unix; then
  module_symlink "dotfiles/src/dot.tmux" ".tmux"
fi
echo "# TASK [Ensure that .vimrc exists]"
if true; then
  module_symlink "dotfiles/src/dot.vimrc" ".vimrc"
fi
echo "# TASK [Ensure that nvim is configured]"
if is_windows; then
  module_symlink "dotfiles/src/AppData/Local/nvim" "AppData/Local/nvim"
fi
echo "# TASK [Ensure that WindowsTerminal directory exists]"
if is_windows; then
  module_directory "AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/" ""
fi
echo "# TASK [Ensure that WindowsTerminal is configured]"
if is_windows; then
  module_symlink "dotfiles/src/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" "AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
fi
echo "# TASK [Ensure that gtk directory exists]"
if is_windows; then
  module_directory "AppData/Local/gtk-3.0/" ""
fi
echo "# TASK [Ensure that gtk is configured]"
if is_windows; then
  module_symlink "dotfiles/src/AppData/Local/gtk-3.0/settings.ini" "AppData/Local/gtk-3.0/settings.ini"
fi
echo "# TASK [Ensure that alacritty is configured]"
if is_windows; then
  module_symlink "dotfiles/src/AppData/Roaming/alacritty" "AppData/Roaming/alacritty"
fi
echo "# TASK [Ensure that .vim exists]"
if true; then
  module_symlink "dotfiles/src/dot.vim" ".vim"
fi
echo "# TASK [Ensure that vimfiles/autoload directory exists]"
if is_windows; then
  module_directory "vimfiles/autoload" ""
fi
echo "# TASK [Ensure that .bashrc.d exists]"
if is_unix; then
  module_symlink "dotfiles/src/dot.bashrc.d" ".bashrc.d"
fi
echo "# TASK [Ensure that .gitconfig_local.inc exists]"
if true; then
  module_copy "dotfiles/src/dot.gitconfig_local.inc" ".gitconfig_local.inc" ""
fi
echo "# TASK [Ensure that .gitconfig_profiles.json.sample exists]"
if is_windows; then
  module_symlink "dotfiles/src/dot.gitconfig_profiles.json.sample" ".gitconfig_profiles.json.sample"
fi
echo "# TASK [Ensure that .hgrc_local.inc exists]"
if true; then
  module_copy "dotfiles/src/dot.hgrc_local.ini" ".hgrc_local.ini" ""
fi
echo "# TASK [Ensure that Microsoft.PowerShell_profile.ps1 exists]"
if is_windows; then
  module_copy "dotfiles/src/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1" "Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1" ""
fi
echo "# TASK [Ensure that Documents/PowerShell exists]"
if is_windows; then
  module_directory "Documents/PowerShell" ""
fi
echo "# TASK [Ensure that Microsoft.PowerShell_profile.ps1 exists]"
if is_windows; then
  module_copy "dotfiles/src/Documents/PowerShell/Microsoft.PowerShell_profile.ps1" "Documents/PowerShell/Microsoft.PowerShell_profile.ps1" ""
fi
echo "# TASK [Ensure that Microsoft.PowerShell_profile.ps1 exists]"
if is_unix; then
  module_symlink "dotfiles/src/.config/powershell/Microsoft.PowerShell_profile.ps1" "dot.config/powershell/Microsoft.PowerShell_profile.ps1"
fi
echo "# TASK [Ensure that .powershellrc.ps1 exists]"
if is_windows; then
  module_symlink "dotfiles/src/dot.powershellrc.ps1" ".powershellrc.ps1"
fi
echo "# TASK [Ensure that .ssh exists]"
if is_windows; then
  module_directory ".ssh" ""
fi
echo "# TASK [Ensure that .ssh/wsl-ssh-pageant exists]"
if is_windows; then
  module_symlink "dotfiles/src/dot.ssh_windows/wsl-ssh-pageant" ".ssh/wsl-ssh-pageant"
fi
echo "# TASK [Ensure that .ssh/config exists]"
if is_unix; then
  module_symlink "dotfiles/src/dot.ssh/config" ".ssh/config"
fi
echo "# TASK [Ensure that .bash_profile exists]"
if is_unix; then
  module_copy "dotfiles/src/dot.bash_profile" ".bash_profile" ""
fi
echo "# TASK [Ensure that .bashrc exists]"
if is_unix; then
  module_touch ".bashrc"
fi
echo "# TASK [Ensure that .bashrc is configured]"
if is_unix; then
  module_lineinfile ".bashrc" "source $HOME/.bashrc_local.sh"
fi

