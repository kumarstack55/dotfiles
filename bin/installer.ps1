[CmdletBinding(SupportsShouldProcess)]
param()

Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"

function EnsureUserHasAdminPriviledge {
    if (-not (([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [Security.Principal.WindowsBuiltInRole] "Administrator"))) {
        Write-Warning "管理者権限で実行してください"
        exit 1
    }
}

function ConvertFromPsoToHashtable {
    param([PSCustomObject]$Pso)
    $Hashtable = @{}
    foreach ($name in $Pso.psobject.Properties.Name) {
        $Hashtable[$name] = $Pso.$name
    }
    return $Hashtable
}

function GetRepoDir {
    param([string]$ScriptPath)
    $Path = Join-Path (Split-Path -Parent $ScriptPath) ".."
    return [System.IO.Path]::GetFullPath($Path)
}

function Invoke-ActionSymlink {
    param($ItemPath, $Target)

    $FullPath = Join-Path $HOME $ItemPath
    $Path = Split-Path $FullPath -Parent
    $Name = Split-Path $FullPath -Leaf

    if ( ( Test-Path $Target -PathType Container ) -And ( Test-Path $FullPath ) ) {
        (Get-Item $FullPath).Delete()
    }
    New-Item -Force -Path $Path -Name $Name -Value $Target -ItemType SymbolicLink
}

function Invoke-ActionCopy {
    param($ItemPath, $Target)
    $FullPath = Join-Path $HOME $ItemPath
    Copy-Item $Target $FullPath
}

function WhenPathNotExists() {
    param($ItemPath)
    $Path = Join-Path $HOME $ItemPath
    -not ( Test-Path $Path )
}

function Test-ItemWhen {
    param($Item)
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

function Invoke-ItemAction {
    param($Item)
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

function Test-CommandExists {
    param($Name)

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

class Module {
    run() {
        throw
    }
}

function ConstructModuleSymlinkForSplatting {
    param(
        [Parameter(Mandatory)]$That,
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Src,
        [bool]$Force)
    $That.Path = $Path
    $That.Src = $Src
    $That.Force = $Force
}

class ModuleSymlink : Module {
    [string]$Path
    [string]$Src
    [bool]$Force

    ModuleSymlink([hashtable]$Params) {
        $Params['That'] = $this
        ConstructModuleSymlinkForSplatting @Params
    }
    run() {
        $HomeDir = (Get-Item Env:\USERPROFILE).Value

        $FullPath = Join-Path $HomeDir $this.Path
        $Path2 = Split-Path $FullPath -Parent
        $Name = Split-Path $FullPath -Leaf

        $SrcFullPath = Join-Path $HomeDir $this.src

        if ( ( Test-Path $FullPath ) -And ( Test-Path $Path2 -PathType Container ) ) {
            (Get-Item $FullPath).Delete()
        }
        write-host New-Item -Force -Path $Path2 -Name $Name -Value $SrcFullPath -ItemType SymbolicLink
        New-Item -Force -Path $Path2 -Name $Name -Value $SrcFullPath -ItemType SymbolicLink
    }
}

function ConstractModuleDirectoryForSplatting {
    param(
        [Parameter(Mandatory)]$That,
        [Parameter(Mandatory)][string]$Path,
        [string]$Mode)
    $That.Path = $Path
    $That.Mode = $Mode
}

class ModuleDirectory : Module {
    [string]$Path
    [string]$Mode
    ModuleDirectory([hashtable]$Params) {
        $Params['That'] = $this
        ConstractModuleDirectoryForSplatting @Params
    }
    run() {
        $HomeDir = (Get-Item Env:\USERPROFILE).Value
        $Path2 = Join-Path $HomeDir (Split-Path $this.Path -Parent)
        $Name = Split-Path $this.Path -Leaf
        New-Item -Force -Path $Path2 -Name $Name -ItemType Directory
    }
}

function ConstructModuleCopyForSplatting {
    param(
        [Parameter(Mandatory)]$That,
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Src,
        [bool]$Force = $false
        )
    $That.Path = $Path
    $That.Src = $Src
    $That.Force = $Force
}

class ModuleCopy : Module {
    [string]$Path
    [string]$Src
    [bool]$Force

    ModuleCopy([hashtable]$Params) {
        $Params['That'] = $this
        ConstructModuleCopyForSplatting @Params
    }

    run() {
        $HomeDir = (Get-Item Env:\USERPROFILE).Value
        $DestPath = Join-Path $HomeDir $this.Path
        $SrcPath = Join-Path $HomeDir $this.Src
        Copy-Item -LiteralPath $SrcPath -Destination $DestPath
    }
}

function ConstructModuleTouchForSplatting{
    param(
        [Parameter(Mandatory)]$That,
        [Parameter(Mandatory)][string]$Path)
    $That.Path = $Path
}

class ModuleTouch : Module {
    [string]$Path
    ModuleTouch([hashtable]$Params) {
        $Params['That'] = $this
        ConstructModuleTouchForSplatting @Params
    }
}

function ConstructModuleLineinfileForSplatting {
    param(
        [Parameter(Mandatory)]$That,
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Line)
    $That.Path = $Path
    $That.Line = $Line
}

class ModuleLineinfile : Module {
    [string]$Path
    [string]$Line
    ModuleLineinfile([hashtable]$Params) {
        $Params['That'] = $this
        ConstructModuleLineinfileForSplatting @Params
    }
}

class Task {
    [string]$Name
    [Module]$Module
    $When
    Task([string]$Name, [Module]$Module, $When) {
        $this.Name = $Name
        $this.Module = $Module
        $this.When = $When
    }
}

class Playbook {
    [int]$PlaybookVersion
    $Tasks
    Playbook([int]$PlaybookVersion, $Tasks) {
        $this.PlaybookVersion = $PlaybookVersion
        $this.Tasks = $Tasks
    }
}

class ModuleFactory {
    $ModuleNameToClass
    ModuleFactory() {
        $this.ModuleNameToClass = @{}
    }
    add([string]$ModuleName, $ModuleClass) {
        $this.ModuleNameToClass[$ModuleName] = $ModuleClass
    }
    [Module]create([string]$ModuleName, [hashtable]$Params) {
        $ModuleClass = $this.ModuleNameToClass[$ModuleName]
        return $ModuleClass::new($Params)
    }
}

class TaskFactory {
    [ModuleFactory]$ModuleFactory
    TaskFactory([ModuleFactory]$ModuleFactory) {
        $this.ModuleFactory = $ModuleFactory
    }
    [Task]create([PSCustomObject]$TaskObject) {
        $Name = $TaskObject.name
        $ModuleName = $TaskObject.module

        $ParamsPso = $TaskObject.params
        $Params = ConvertFromPsoToHashtable($ParamsPso)
        $Module = $this.ModuleFactory.create($ModuleName, $Params)

        if ($TaskObject.psobject.Properties.Match("when").Count -eq 1) {
            $When = $TaskObject.when
        } else {
            $When = @('true',@())
        }

        return [Task]::new($Name, $Module, $When)
    }
}

class PlaybookLoader {
    [TaskFactory]$TaskFactory
    PlaybookLoader([TaskFactory]$TaskFactory) {
        $this.TaskFactory = $TaskFactory
    }
    [Playbook]load([string]$PlaybookPath) {
        $Data = Get-Content $PlaybookPath | ConvertFrom-Json

        $Tasks = [System.Collections.ArrayList]::new()
        foreach ($TaskObject in $Data.tasks) {
            $Tasks.Add($this.TaskFactory.create($TaskObject))
        }

        return [Playbook]::new($Data.playbook_version, $Tasks)
    }
}

function EvaluateWhen {
    param([Parameter(Mandatory)][System.Array]$When)

    if ($When.Count -ne 2) {
        throw
    }

    if ($When[0] -ceq 'true') {
        if ($When[1].Count -ne 0) {
            throw '$When[1].Count: {0}' -f $When[1].Count
        }
        return $true
    } elseif ($When[0] -ceq 'is_unix') {
        if ($When[1].Count -ne 0) {
            throw '$When[1].Count: {0}' -f $When[1].Count
        }
        return $false
    } elseif ($When[0] -ceq 'is_windows') {
        if ($When[1].Count -ne 0) {
            throw '$When[1].Count: {0}' -f $When[1].Count
        }
        return $true
    } elseif ($When[0] -ceq 'tmux_version_lt_2pt1') {
        if ($When[1].Count -ne 0) {
            throw '$When[1].Count: {0}' -f $When[1].Count
        }
        return $false
    } elseif ($When[0] -ceq 'tmux_version_ge_2pt1') {
        if ($When[1].Count -ne 0) {
            throw '$When[1].Count: {0}' -f $When[1].Count
        }
        return $false
    } elseif ($When[0] -ceq 'and') {
        foreach ($Item in $When[1]) {
            if (-not (EvaluateWhen($Item))) {
                return $false
            }
        }
        return $true
    } else {
        throw
    }
}

function Main {
    param([Parameter(Mandatory)]$ScriptPath)

    # 管理者権限があるか確認する。
    EnsureUserHasAdminPriviledge

    # プレイブックのパスを得る
    $RepoDir = GetRepoDir $ScriptPath
    $PlaybookPath = Join-Path $RepoDir playbook.json

    # プレイブックを読む。
    $ModuleFactory = [ModuleFactory]::new()
    $ModuleFactory.add('symlink', [ModuleSymlink])
    $ModuleFactory.add('directory', [ModuleDirectory])
    $ModuleFactory.add('touch', [ModuleTouch])
    $ModuleFactory.add('lineinfile', [ModuleLineinfile])
    $ModuleFactory.add('copy', [ModuleCopy])
    $TaskFactory = [TaskFactory]::new($ModuleFactory)
    $Loader = [PlaybookLoader]::new($TaskFactory)
    $Playbook = $Loader.load($PlaybookPath)

    # プレイブックを実行する。
    foreach ($Task in $Playbook.Tasks) {
        $Task2 = [Task]$Task
        Write-Host ('# Task [{0}]' -f $Task2.name)
        Write-Host ('# ' + ('*' * 60))
        if (EvaluateWhen($Task2.when)) {
            $Task2.module.run()
            Write-Host "ok"
        } else {
            Write-Host "skipping"
        }
        Write-Host ""
    }

#    # インベントリを配置する
#    Get-Content (Join-Path $RepoDir inventory.json) |
#        ConvertFrom-Json |
#        Select-Object -ExpandProperty inventory |
#        Where-Object { Test-ItemOs -ItemOs $_.os } |
#        Where-Object { Test-ItemWhen -Item $_ } |
#        Foreach-Object { Invoke-ItemAction -Item $_ }
#
#    # vim-plug をインストールする
#    $cli = New-Object System.Net.WebClient
#    $utf8WithoutBom = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)
#    if (-not (Test-Path $HOME/.vimfiles/autoload/plug.vim)) {
#        $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
#        $str = $cli.DownloadString($uri)
#        [System.IO.File]::WriteAllText("$HOME\vimfiles\autoload\plug.vim", @($str), $utf8WithoutBom)
#    }
#    if (-not (Test-Path $HOME/AppData/Local/nvim/autoload/plug.vim)) {
#        mkdir -Force ~\AppData\Local\nvim\autoload
#        $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
#        $str = $cli.DownloadString($uri)
#        [System.IO.File]::WriteAllText("$HOME\AppData\Local\nvim\autoload\plug.vim", @($str), $utf8WithoutBom)
#    }
#
#    #if (Test-CommandExists nvim) {
#    #    if ($PSCmdlet.ShouldProcess('nvim', 'PlugInstall')) {
#    #        nvim -u "~/.config/nvim/plugins.vim " -c "try | PlugInstall --sync | finally | qall! | endtry"
#    #    }
#    #}
}

# ファンクションの中でスクリプトパスを取得できないため、ここで得る
$ScriptPath = $MyInvocation.MyCommand.Path

Main $ScriptPath

# vm:ts=2 sw=2 sts=2 et ai:
