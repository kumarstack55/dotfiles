Set-StrictMode -Version Latest

$Path = Split-Path -Parent $MyInvocation.MyCommand.Path
$ArgList = ("-NoExit", "-Command", "cd $Path")
Start-Process powershell.exe $ArgList -Verb runas
