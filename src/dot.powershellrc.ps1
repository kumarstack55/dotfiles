# このファイルは $PROFILE から呼ばれる
Function Prompt {
    #"PS " + $(Get-Location) + "> "
    "PS " + $(Split-Path (Get-Location) -Leaf) + "> "
}
