# このファイルは $PROFILE から呼ばれる。

$Script:MyDotfilePrompt = 0

function PromptDefault {
    <#
        .SYNOPSIS
        既定のプロンプト定義です。
        (Get-Command prompt).Definition で得たコードを再定義しています。
    #>
    "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}

function PromptSimple {
    <#
        .SYNOPSIS
        パスに関する情報を出力しないプロンプト定義です。
    #>
    "PS $('>' * ($nestedPromptLevel + 1)) "
}

function Get-MyPromptDebugRole {
    <#
        .SYNOPSIS
        管理者として実行の場合、デバッグコンテキストの文字列を返します。
    #>
    $Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = [Security.Principal.WindowsPrincipal] $Identity
    $AdminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
    if (Test-Path variable:/PSDebugContext) { '[DBG] ' }
    elseif ($Principal.IsInRole($AdminRole)) { '[ADMIN] ' }
    else { '' }
}

function Get-MyPromptPoetry {
    <#
        .SYNOPSIS
        Poetry が有効な場合の文字列を返します。
    #>
    if (Test-Path env:POETRY_ACTIVE) { '[Poetry] ' }
    else { '' }
}

function Get-MyPromptVersionString {
    <#
        .SYNOPSIS
        PowerShell のバージョンを返します。
    #>
    $Version = $PSVersionTable.PSVersion
    'v' + $Version.Major + '.' + $Version.Minor
}

function PromptComplex {
    <#
        .SYNOPSIS
        管理者か、Poetry有効か、バージョン、ユーザ、ホスト、作業ディレクトリ、などを出力するプロンプト定義です。
    #>
    $DebugRole = Get-MyPromptDebugRole
    $Poetry = Get-MyPromptPoetry
    $VersionString = Get-MyPromptVersionString
    $UserName = $env:UserName
    $HostName = $Env:Computername
    $UserHostName = $UserName + '@' + $HostName
    $ParentDirectory = $(Split-Path (Get-Location) -Leaf)

    $Prompt = ''
    $Prompt += "`r`n"
    $Prompt += $DebugRole + $Poetry + $VersionString + ' ' + $UserHostName + ':' + $ParentDirectory + "`r`n"
    $Prompt += PromptSimple

    $Prompt
}

function Prompt {
    if ($Script:MyDotfilePrompt -eq 0) {
        return PromptDefault
    } elseif ($Script:MyDotfilePrompt -eq 1) {
        return PromptComplex
    } else {
        return PromptSimple
    }
}

function MyPromptSwitch {
    <#
        .SYNOPSIS
        プロンプトを切り替えます。
    #>
    $Script:MyDotfilePrompt += 1
    $Script:MyDotfilePrompt %= 3
}

function Get-MyPSVersionMajor {
    <#
        .SYNOPSIS
        PowerShell のメジャーバージョンを得る。
    #>
    $PSVersionTable.PSVersion.Major
}

function Test-MyPSVersionMajorEq7 {
    <#
        .SYNOPSIS
        PowerShell のバージョンが 7 か判定する。
    #>
    Get-MyPSVersionMajor -eq 7
}

function Test-MyPSVersionMajorEq5 {
    <#
        .SYNOPSIS
        PowerShell のバージョンが 5 か判定する。
    #>
    Get-MyPSVersionMajor -eq 5
}

function Get-MyGitConfigProfiles {
    <#
        .SYNOPSIS
        git configのプロファイルを得る。
    #>
    $JsonPath = Join-Path $HOME ".gitconfig_profiles.json"
    if (-not (Test-Path $JsonPath)) {
        throw "ファイル $JsonPath が存在しなかった。"
    }
    $Data = Get-Content $JsonPath | ConvertFrom-Json
    $Data.profiles
}

function Get-MyGitConfigProfileIdToConfigHashtable {
    <#
        .SYNOPSIS
        git configのプロファイルのIDと設定のハッシュテーブルを得る。
    #>
    $Hashtable = @{}

    Get-MyGitConfigProfiles |
    ForEach-Object {
        $Hashtable[$_.id] = $_.config
    }

    $Hashtable
}

function Set-MyGitConfig {
    <#
        .SYNOPSIS
        git configを設定する。
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param([parameter(Mandatory)][String]$ProfileId)

    $IdConfigHashtable = Get-MyGitConfigProfileIdToConfigHashtable
    $ProfileConfig = $IdConfigHashtable[$ProfileId]
    $User = $ProfileConfig.user
    $User.psobject.Properties.Name |
    ForEach-Object {
        $Name = "user.$_"
        $Value = $User.$_
        $Target = "git config $Name $Value"
        if($PSCmdlet.ShouldProcess($Target)){
            git config $Name $Value
        }
    }
}

# 既定では、タブキーでの補完は、完全なコマンドを出力する。
# タブキーでの補完は、bashのようにファイルの途中までにする。
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# PowerShell 5 で既定では、 curl は Web-Request のエイリアスである。
# PowerShell 7 では、 curl はエイリアスではない。
# 別途インストールすれば curl を実行できるようにするため、エイリアスを消す。
Get-Alias |
Where-Object { $_.Name -eq "curl" } |
ForEach-Object { Remove-Item -LiteralPath "Alias:$($_.Name)" }
