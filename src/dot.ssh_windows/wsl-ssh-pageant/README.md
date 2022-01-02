* https://github.com/benpye/wsl-ssh-pageant
    * releases pages
* https://github.com/benpye/wsl-ssh-pageant/releases
    * wsl-ssh-pageant-amd64-gui.exe
* ショートカットを作る。
    * `C:\Users\xxx\.ssh\wsl-ssh-pageant\wsl-ssh-pageant-amd64-gui.exe --systray --winssh ssh-pageant`
* `shell:startup` にショートカットを置く。
* `$env:SSH_AUTH_SOCK = '\\.\pipe\ssh-pageant'`

