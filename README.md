![CI](https://github.com/kumarstack55/dotfiles/workflows/CI/badge.svg)

# dotfiles

## 対応OS

* ArchLinux
* Debian
* EL7
* macOS
* Windows+mintty

## 要件

* git

## インストール

### macOS, EL7, Debian, Ubuntu, Windows+mintty

```bash
cd /tmp
curl -LO https://raw.githubusercontent.com/kumarstack55/dotfiles/master/bootstrap.sh
chmod -v +x bootstrap.sh
./bootstrap.sh
```

または

```bash
cd $HOME
git clone git@github.com:kumarstack55/dotfiles.git

cd $HOME
dotfiles/bin/installer.sh
```

### Windows+PowerShell

シンボリックリンクを扱うため PowerShell を管理者権限で実行する。

```ps1
cd $HOME
git clone git@github.com:kumarstack55/dotfiles.git

cd $HOME/dotfiles/bin
./installer.ps1
```

## 変更する場合

```sh
cd $HOME/dotfiles
npm install commitizen
npm install cz-conventional-changelog
exec $SHELL -l
npm run commit
```
