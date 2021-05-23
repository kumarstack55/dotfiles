![CI](https://github.com/kumarstack55/dotfiles/workflows/CI/badge.svg)

# dotfiles

## 対応OS

* macOS
* EL7
* Debian
* ArchLinux
* Windows+mintty

## インストール

### macOS, EL7, debian, Windows+mintty

```bash
cd $HOME
git clone git@github.com:kumarstack55/dotfiles.git

cd $HOME/dotfiles/bin
./installer.sh

pip install -U --user pynvim
pip install --user flake8
```

### Windows+PowerShell

シンボリックリンクを扱うため PowerShell を管理者権限で実行する。

```ps1
cd $HOME
git clone git@github.com:kumarstack55/dotfiles.git

cd $HOME/dotfiles/bin
./installer.ps1

pip install -U --user pynvim
pip install --user flake8
```

## 変更する場合

```sh
cd $HOME/dotfiles
npm install commitizen
npm install cz-conventional-changelog
exec $SHELL -l
npm run commit
```
