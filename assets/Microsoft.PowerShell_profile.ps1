#region powershell configuration
[Net.ServicePointManager]::SecurityProtocol =
    [Net.ServicePointManager]::SecurityProtocol -bor
    [Net.SecurityProtocolType]::Tls12

[console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
#endregion

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\Users\cloud\miniconda3\Scripts\conda.exe") {
    (& "C:\Users\cloud\miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
$Env:_CE_M = $null
$Env:_CE_CONDA = $null
#endregion

#region oh-my-posh initialize
(@(& "C:\\Users\\cloud\\AppData\\Local\\Programs\\oh-my-posh\\bin\\oh-my-posh.exe" init pwsh --config="~\Documents\PowerShell\nks.omp.json" --print) -join "`n") | Invoke-Expression
#endregion

#region fnm initialize
fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression
#endregion

#region modules initialize
Import-Module -Name Terminal-Icons
#endregion

#region keybindings initialize
Set-PSReadLineKeyHandler -Chord "Ctrl+d" -Function ForwardWord
Set-PSReadLineKeyHandler -Chord "Ctrl+s" -Function HistorySearchBackward
#endregion

#region aliases initialize
Set-Alias -Name RemoveHistory -Value "D:\nklowns\nklowns\assets\scripts\ps1\Pwsh_RemoveLastHistory.ps1"
Set-Alias -Name Git_WorkflowClickup -Value "D:\nklowns\nklowns\assets\scripts\ps1\Git_WorkflowClickup.ps1"
Set-Alias -Name Git_LogsTableClickup -Value "D:\nklowns\nklowns\assets\scripts\ps1\Git_LogsTableClickup.ps1"
#endregion

echo "PowerShell.Profile"

if ($env:TERM_PROGRAM -eq "vscode") { . "$(code --locate-shell-integration-path pwsh)" }
