[Net.ServicePointManager]::SecurityProtocol =
    [Net.ServicePointManager]::SecurityProtocol -bor
    [Net.SecurityProtocolType]::Tls12

[console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\Users\cloud\miniconda3\Scripts\conda.exe") {
    (& "C:\Users\cloud\miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
$Env:_CE_M = $null
$Env:_CE_CONDA = $null
#endregion

(@(& "C:\\Users\\cloud\\AppData\\Local\\Programs\\oh-my-posh\\bin\\oh-my-posh.exe" init pwsh --config="~\Documents\PowerShell\nks.omp.json" --print) -join "`n") | Invoke-Expression

fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression

Import-Module -Name Terminal-Icons

Set-PSReadLineKeyHandler -Chord "Ctrl+d" -Function ForwardWord
Set-PSReadLineKeyHandler -Chord "Ctrl+s" -Function HistorySearchBackward

echo "PowerShell.Profile"

if ($env:TERM_PROGRAM -eq "vscode") { . "$(code --locate-shell-integration-path pwsh)" }
