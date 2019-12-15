# dotfiles

## インストール

### macOS

TODO

### EL7

TODO

### Windows

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
nvim -c "try | PlugInstall | finally | qall! | endtry"
```