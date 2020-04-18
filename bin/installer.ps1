[CmdletBinding(SupportsShouldProcess)]
Param()

Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"

Function GetSrcDir {
    Param($Path)
    $Path = Join-Path (Split-Path -Parent $Path) ".."
    $LocalRepoDir = [System.IO.Path]::GetFullPath($Path)
    $SrcDir = Join-Path $LocalRepoDir "src"
    return $SrcDir
}

Function ConfirmAdministratorPriviledge {
    if (-not (([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [Security.Principal.WindowsBuiltInRole] "Administrator"))) {
        Write-Warning "管理者権限で実行してください"
        exit 1
    }
}

Function Main {
    Param([Parameter(Mandatory)]$Path)

    # ローカルリポジトリのパスを得る
    $SrcDir = GetSrcDir $Path

    # 管理者権限があるか確認する
    ConfirmAdministratorPriviledge

    # なければディレクトリを作る
    New-Item -Force -Path $HOME -Name .config -ItemType Directory
    New-Item -Force -Path $HOME/.config -Name nvim -ItemType Directory
    New-Item -Force -Path $HOME/AppData/Local -Name nvim -ItemType Directory

    # ファイルのシンボリックリンクを上書きで作る
    New-Item -Force -Path $HOME -Name .ctags -Value $SrcDir/dot.ctags -ItemType SymbolicLink
    New-Item -Force -Path $HOME -Name .editorconfig -Value $SrcDir/dot.editorconfig -ItemType SymbolicLink
    New-Item -Force -Path $HOME -Name .gitconfig -Value $SrcDir/dot.gitconfig -ItemType SymbolicLink
    New-Item -Force -Path $HOME -Name .gitconfig_windows.inc -Value $SrcDir/dot.gitconfig_windows.inc -ItemType SymbolicLink
    New-Item -Force -Path $HOME -Name _gvimrc -Value $SrcDir/dot.gvimrc -ItemType SymbolicLink
    New-Item -Force -Path $HOME -Name .vimrc -Value $SrcDir/dot.vimrc -ItemType SymbolicLink
    New-Item -Force -Path $HOME/AppData/Local/nvim -Name init.vim -Value $SrcDir/dot.config/nvim/init_windows.vim -ItemType SymbolicLink
    New-Item -Force -Path $HOME/AppData/Local/nvim -Name plugins.vim -Value $SrcDir/dot.config/nvim/plugins.vim -ItemType SymbolicLink

    # ディレクトリのシンボリックリンクを上書きで作る
    if (Test-Path $HOME/.vim) {
        (Get-Item $HOME/.vim).Delete()
    }
    New-Item -Force -Path $HOME -Name .vim -Value $SrcDir/dot.vim -ItemType SymbolicLink
    if (Test-Path $HOME/.config/nvim) {
        (Get-Item $HOME/.config/nvim).Delete()
    }
    New-Item -Force -Path $HOME/.config -Name nvim -Value $SrcDir/dot.config/nvim -ItemType SymbolicLink

    # なければコピーする
    if (-not (Test-Path $HOME/.gitconfig_local.inc)) {
        Copy-Item $SrcDir/dot.gitconfig_local.inc $HOME/.gitconfig_local.inc
    }

    # vim-plug をインストールする
    if (-not (Test-Path $HOME/.vim/autoload/plug.vim)) {
        md -Force ~\vimfiles\autoload
        $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        (New-Object Net.WebClient).DownloadFile(
            $uri,
            $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
            "~\vimfiles\autoload\plug.vim"
            )
        )
    }
    if (-not (Test-Path $HOME/AppData/Local/nvim/autoload/plug.vim)) {
        md -Force ~\AppData\Local\nvim\autoload
        $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        (New-Object Net.WebClient).DownloadFile(
            $uri,
            $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
            "~\AppData\Local\nvim\autoload\plug.vim"
            )
        )
    }

    # nvimプラグインをインストールする
    $nvim_exists = $null
    try {
        Get-Command nvim | Out-Null
        $nvim_exists = $True
    } catch [System.Management.Automation.ActionPreferenceStopException] {
        $nvim_exists = $False
    }
    if ($nvim_exists) {
        if ($PSCmdlet.ShouldProcess('nvim', 'PlugInstall')) {
            nvim -u "~/.config/nvim/plugins.vim " -c "try | PlugInstall --sync | finally | qall! | endtry"
        }
    }
}

# ファンクションの中でスクリプトパスを取得できないため、ここで得る
$Path = $MyInvocation.MyCommand.Path

Main $Path

# vm:ts=2 sw=2 sts=2 et ai:
