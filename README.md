# dotfiles

## macOS / EL7 / debian

```bash
cd $HOME
git clone git@github.com:kumarstack55/dotfiles.git

cd $HOME/dotfiles/bin
./installer.sh

# for python2
pip install --user neovim

# for python3
pip install --user pynvim

nvim -u "~/.config/nvim/plugins.vim" -c "try | PlugInstall | finally | qall! | endtry"

pip install --user flake8
```

## Windows + PowerShell

* Win + R
* powershell.exe

```
cd $HOME
git clone git@github.com:kumarstack55/dotfiles.git

cd $HOME/dotfiles/bin
./start-powershell-runas.ps1
```

```
./installer.ps1
exit
```

```
# for python2
pip install --user neovim

# for python3
pip install --user pynvim

nvim -u "~/AppData/Local/nvim/plugins.vim" -c "try | PlugInstall | finally | qall! | endtry"

pip install --user flake8
```

## Windows + mintty

* Options - Text - Font: Cica, 14pt
* Options - Terminal - Type: xterm-256color

```bash
cd $HOME
git clone git@github.com:kumarstack55/dotfiles.git

cd $HOME/dotfiles/bin
./installer.sh
```

## ディレクトリ構造

```
unix: linux, macos, git-bash
any : unix + windows

* $HOME/
    * AppData/
        * Local/
            * nvim/                            [os:windows, action:directory]
                * init.vim                     [os:windows, action:symlink,   target:dot.config/nvim/init_windows.vim]
                * plugins.vim                  [os:windows, action:symlink,   target:dot.config/nvim/plugins.vim]
    * Documents/
        * WindowsPowerShell/
            * Microsoft.PowerShell_profile.ps1 [os:windows, action:copy,      target:Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1]
    * .bashrc_local.sh                         [os:unix,    action:symlink,   target:dot.bashrc_local.sh]
    * .bashrc.d                                [os:unix,    action:symlink,   target:dot.bashrc.d]
    * .bash_profile                            [os:unix,    action:copy,      when:path_not_exists]
    * .bash_profile                            [os:unix,    action:append]
    * .config/                                 [os:any,     action:directory]
        * nvim/                                [os:windows, action:directory]
        * nvim/                                [os:unix,    action:symlink,   target:dot.config/nvim]
    * .ctags                                   [os:any,     action:symlink,   target:dot.ctags]
    * .editorconfig                            [os:any,     action:symlink,   target:dot.editorconfig]
    * .gitconfig                               [os:any,     action:symlink,   target:dot.gitconfig]
    * .gitconfig_windows.inc                   [os:windows, action:symlink,   target:dot.gitconfig_windows.inc]
    * .gitconfig_local.inc                     [os:any,     action:copy,      target:dot.gitconfig_local.inc, when:path_not_exists]
    * .gvimrc                                  [os:unix,    action:symlink,   target:dot.gvimrc]
    * .inputrc                                 [os:unix,    action:symlink,   target:dot.inputrc]
    * .powershellrc.ps1                        [os:windows, action:symlink,   target:dot.powershellrc.ps1]
    * .ssh/                                    [os:unix,    action:directory, mode: 0700]
        * config                               [os:unix,    action:symlink,   target:dot.ssh/config, when:path_not_exists]
    * .tmux.conf                               [os:unix,    action:symlink,   target:dot.tmux.conf.lt_v2.1, when:tmux_version <  2.1]
    * .tmux.conf                               [os:unix,    action:symlink,   target:dot.tmux.conf.ge_v2.1, when:tmux_version >= 2.1]
    * .tmux.conf.all                           [os:unix,    action:symlink,   target:dot.tmux.conf.all]
    * .vim/                                    [os:any,     action:symlink,   target:dot.vim]
        * autoload/                            [os:windows, action:directory]
            * plug.vim                         [os:windows, action:copy]
    * .vimrc                                   [os:windows, action:symlink,   target:dot.vimrc]
    * _gvimrc                                  [os:windows, action:symlink,   target:dot.gvimrc]
```