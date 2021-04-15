# このファイルは $PROFILE から呼ばれる

# プロンプト表示はディレクトリのみとする
Function Prompt {
    #"PS " + $(Get-Location) + "> "
    "PS " + $(Split-Path (Get-Location) -Leaf) + "> "
}

# タブキーでの補完は、bashのようにファイルの途中までにする
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# curl を実行するときは curl を使いたいのであって Web-Request を使いたくない
Remove-Item Alias:curl
