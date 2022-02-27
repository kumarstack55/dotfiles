# このファイルは $PROFILE から呼ばれる。

$Script:MyDotfilePromptSimple = 0
$Script:MyDotfilePrompt = 0

function PromptSwitch {
    $Script:MyDotfilePrompt += 1
    $Script:MyDotfilePrompt %= 2
}

# 既定では、プロンプト表示はカレントディレクトリの完全なパスを含む。
# プロンプト表示はカレントディレクトリの名前とする。
function Prompt {
    $Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = [Security.Principal.WindowsPrincipal] $Identity
    $AdminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
    $Version = $PSVersionTable.PSVersion

    $DebugRole = $(
        if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
        elseif ($Principal.IsInRole($AdminRole)) { '[ADMIN]: ' }
        else { '' }
    )
    $VersionString = 'v' + $Version.Major + '.' + $Version.Minor
    $UserName = $env:UserName
    $HostName = $Env:Computername
    $ParentDirectory = $(Split-Path (Get-Location) -Leaf)

    $Prompt = ''
    if ($Script:MyDotfilePrompt -ne $Script:MyDotfilePromptSimple) {
        $Prompt += "`r`n"
        $Prompt += $DebugRole + $VersionString + ' ' + $UserName + '@' + $HostName + ':' + $ParentDirectory + ' ' + "`r`n"
    }
    $Prompt += 'PS ' + $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '

    $Prompt
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
