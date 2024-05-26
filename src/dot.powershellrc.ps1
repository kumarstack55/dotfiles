# このファイルは $PROFILE から呼ばれる。

# git 用のエディタを環境変数で指定する。
# git-bash, PowerShell 共通で $HOME/.gitconfig を参照する。
# しかし git-bash では winpty 経由で nvim, vim を実行する必要があり、
# $HOME/.gitconfig で同一のエディタを指定することは困難である。
foreach ($Editor in @('nvim', 'vim')) {
    Get-Command $Editor -ErrorAction SilentlyContinue | Out-Null
    if ($? -eq $true) {
        $Env:EDITOR = $Editor
        break
    }
}

$script:DotfilePrompt = 0

function Prompt {
    switch ($script:DotfilePrompt) {
        1 {
            # パスに関する情報を出力しないプロンプト定義です。
            "PS $('>' * ($nestedPromptLevel + 1)) "
        }
        default {
            # 既定のプロンプト定義です。
            # (Get-Command prompt).Definition で得たコードを再定義しています。
            "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
        }
    }
}

function Invoke-DotfilesSwitchPrompt {
    <#
        .SYNOPSIS
        プロンプトを切り替えます。
    #>
    $script:DotfilePrompt += 1
    $script:DotfilePrompt %= 2
}

function Set-MyPromptSwitch {
    <#
        .SYNOPSIS
        プロンプトを切り替えます。
    #>
    Write-Warning "Deprecated. Use Invoke-DotfilesSwitchPrompt instead."
    Invoke-DotfilesSwitchPrompt
}

function MyPromptSwitch {
    Set-MyPromptSwitch
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
