[CmdletBinding(SupportsShouldProcess)]
Param()

Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"

Function ConfirmAdministratorPriviledge {
    if (-not (([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [Security.Principal.WindowsBuiltInRole] "Administrator"))) {
        Write-Warning "管理者権限で実行してください"
        exit 1
    }
}

Function GetRepoDir {
    Param($ScriptPath)
    $Path = Join-Path (Split-Path -Parent $ScriptPath) ".."
    return [System.IO.Path]::GetFullPath($Path)
}

Function GetSrcDir {
    Param($ScriptPath)
    $RepoDir = GetRepoDir $ScriptPath
    return Join-Path $RepoDir "src"
}

Function Test-ItemOs {
    Param($ItemOs)
    @("any", "windows").Contains($ItemOs)
}

Function Invoke-ActionDirectory {
    Param($ItemPath)
    $Path = Join-Path $HOME (Split-Path $ItemPath -Parent)
    $Name = (Split-Path $ItemPath -Leaf)
    New-Item -Force -Path $Path -Name $Name -ItemType Directory
}

Function Invoke-ActionSymlink {
    Param($ItemPath, $Target)

    $FullPath = Join-Path $HOME $ItemPath
    $Path = Split-Path $FullPath -Parent
    $Name = Split-Path $FullPath -Leaf

    if ( ( Test-Path $Target -PathType Container ) -And ( Test-Path $FullPath ) ) {
        (Get-Item $FullPath).Delete()
    }
    New-Item -Force -Path $Path -Name $Name -Value $Target -ItemType SymbolicLink
}

Function Invoke-ActionCopy {
    Param($ItemPath, $Target)
    $FullPath = Join-Path $HOME $ItemPath
    Copy-Item $Target $FullPath
}

Function WhenPathNotExists() {
    Param($ItemPath)
    $Path = Join-Path $HOME $ItemPath
    -not ( Test-Path $Path )
}

Function Test-ItemWhen {
    Param($Item)
    if ( $Item.PSObject.Properties.Name -match "when" ) {
        $When = ($Item | Select-Object -ExpandProperty "when")
        Switch ($When) {
            "path_not_exists" {
                return WhenPathNotExists $Item.path
            }
            default {
                throw "unknown when ${When}"
            }
        }
    }
    return $True
}

Function Invoke-ItemAction {
    Param($Item)
    Switch ($Item.action) {
        "directory" {
            Invoke-ActionDirectory -ItemPath $Item.path
        }
        "symlink" {
            $Target = Join-Path $SrcDir $Item.target
            Invoke-ActionSymlink -ItemPath $Item.path -Target $Target
        }
        "copy" {
            $Target = Join-Path $SrcDir $Item.target
            Invoke-ActionCopy -ItemPath $Item.path -Target $Target
        }
        default {
            throw "unknown action"
        }
    }
}

Function Main {
    Param([Parameter(Mandatory)]$ScriptPath)

    # ローカルリポジトリのパスを得る
    $RepoDir = GetRepoDir $ScriptPath
    $SrcDir = GetSrcDir $ScriptPath

    # 管理者権限があるか確認する
    ConfirmAdministratorPriviledge

    # インベントリを配置する
    Get-Content (Join-Path $RepoDir inventory.json) |
        ConvertFrom-Json |
        Select-Object -ExpandProperty inventory |
        Where-Object { Test-ItemOs -ItemOs $_.os } |
        Where-Object { Test-ItemWhen -Item $_ } |
        Foreach-Object { Invoke-ItemAction -Item $_ }

    # ファイルのシンボリックリンクを上書きで作る
    #New-Item -Force -Path $HOME/AppData/Local/nvim -Name plugins.vim -Value $SrcDir/dot.config/nvim/plugins.vim -ItemType SymbolicLink

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

    #
    # プラグインのインストール前にPython用のパッケージが必要であるため、
    # installer.ps1 ではコメントアウトしている
    #

    # nvimプラグインをインストールする
    #$nvim_exists = $null
    #try {
    #    Get-Command nvim | Out-Null
    #    $nvim_exists = $True
    #} catch [System.Management.Automation.ActionPreferenceStopException] {
    #    $nvim_exists = $False
    #}
    #if ($nvim_exists) {
    #    if ($PSCmdlet.ShouldProcess('nvim', 'PlugInstall')) {
    #        nvim -u "~/.config/nvim/plugins.vim " -c "try | PlugInstall --sync | finally | qall! | endtry"
    #    }
    #}
}

# ファンクションの中でスクリプトパスを取得できないため、ここで得る
$ScriptPath = $MyInvocation.MyCommand.Path

Main $ScriptPath

# vm:ts=2 sw=2 sts=2 et ai:
