# このファイルは $PROFILE から呼ばれる。

# 既定では、プロンプト表示はカレントディレクトリの完全なパスを含む。
# プロンプト表示はカレントディレクトリの名前とする。
function Prompt {
    "PS " + $(Split-Path (Get-Location) -Leaf) + "> "
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

# 既定では、タブキーでの補完は、完全なコマンドを出力する。
# タブキーでの補完は、bashのようにファイルの途中までにする。
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# PowerShell 5 で既定では、 curl は Web-Request のエイリアスである。
# PowerShell 7 では、 curl はエイリアスではない。
# 別途インストールすれば curl を実行できるようにするため、エイリアスを消す。
Get-Alias |
Where-Object { $_.Name -eq "curl" } |
ForEach-Object { Remove-Item -LiteralPath "Alias:$($_.Name)" }
