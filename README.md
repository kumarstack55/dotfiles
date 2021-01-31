![CI](https://github.com/kumarstack55/dotfiles/workflows/CI/badge.svg)

# dotfiles

## インストール

### macOS, EL7, debian, Windows+PuTTY, Windows+mintty

* Windows + PuTTY の場合のみ次の設定をする:
    * Window
        * Appearance
            * Font: Cica, 14pt
    * Connection
        * SSH
            * Auth
                * [x] Allow agent forwarding
* Windows + mintty の場合のみ次の設定をする:
    * Options - Text - Font: Cica, 14pt
    * Options - Terminal - Type: xterm-256color

```bash
#sudo apt install git -y
#sudo yum install git -y

cd $HOME
git clone git@github.com:kumarstack55/dotfiles.git

cd $HOME/dotfiles/bin
./installer.sh

pip install --user flake8

# dotfiles を変更する場合
cd $HOME/dotfiles
npm install commitizen
npm install cz-conventional-changelog
exec $SHELL -l
npm run commit
```

### Windows+PowerShell

PowerShell を管理者権限で実行する。

```ps1
cd $HOME
git clone git@github.com:kumarstack55/dotfiles.git

cd $HOME/dotfiles/bin
./installer.ps1

pip install --user flake8
```

## ディレクトリ構造

```
unix: linux, macos, git-bash
any : unix + windows

* $HOME/
    * AppData/
        * Local/
            * nvim/                            [os:windows, action:symlink,   target:AppData\Local\nvim]
    * Documents/
        * WindowsPowerShell/
            * Microsoft.PowerShell_profile.ps1 [os:windows, action:copy,      target:Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1]
    * .ansible.cfg                             [os:unix,    action:symlink,   target:dot.ansible.cfg]
    * .bashrc_local.sh                         [os:unix,    action:symlink,   target:dot.bashrc_local.sh]
    * .bashrc.d                                [os:unix,    action:symlink,   target:dot.bashrc.d]
    * .bash_profile                            [os:unix,    action:copy,      when:path_not_exists]
    * .bash_profile                            [os:unix,    action:append]
    * .config/                                 [os:any,     action:directory]
        * nvim/                                [os:any,     action:symlink,   target:dot.config/nvim]
        * pip/                                 [os:unix,    action:symlink,   target:dot.config/pip]
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

## License

MIT
