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

Function Test-CommandExists {
    Param($Name)

    try {
        Get-Command -Name $Name -ErrorAction Stop | Out-Null
        return $True
    } catch [System.Management.Automation.ActionPreferenceStopException] {
        $e = $_.Exception
        if ($e -is [System.Management.Automation.CommandNotFoundException]) {
            return $False
        }
        Throw $_
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

    # vim-plug をインストールする
    $cli = New-Object System.Net.WebClient
    $utf8WithoutBom = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)
    if (-not (Test-Path $HOME/.vimfiles/autoload/plug.vim)) {
        $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        $str = $cli.DownloadString($uri)
        [System.IO.File]::WriteAllText("$HOME\vimfiles\autoload\plug.vim", @($str), $utf8WithoutBom)
    }
    if (-not (Test-Path $HOME/AppData/Local/nvim/autoload/plug.vim)) {
        md -Force ~\AppData\Local\nvim\autoload
        $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        $str = $cli.DownloadString($uri)
        [System.IO.File]::WriteAllText("$HOME\AppData\Local\nvim\autoload\plug.vim", @($str), $utf8WithoutBom)
    }

    #if (Test-CommandExists nvim) {
    #    if ($PSCmdlet.ShouldProcess('nvim', 'PlugInstall')) {
    #        nvim -u "~/.config/nvim/plugins.vim " -c "try | PlugInstall --sync | finally | qall! | endtry"
    #    }
    #}
}

# ファンクションの中でスクリプトパスを取得できないため、ここで得る
$ScriptPath = $MyInvocation.MyCommand.Path

Main $ScriptPath

# vm:ts=2 sw=2 sts=2 et ai:
