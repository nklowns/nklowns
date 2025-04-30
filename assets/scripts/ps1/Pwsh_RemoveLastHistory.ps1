# Função para remover o último comando do histórico
function Remove-LastHistory {
    # Obter o último comando do histórico
    $lastCommand = (Get-History | Select-Object -Last 1)

    if ($null -eq $lastCommand) {
        Write-Host "O histórico está vazio." -ForegroundColor Yellow
        return
    }

    # Mostrar o comando e pedir confirmação
    Write-Host "Último comando: $($lastCommand.CommandLine)" -ForegroundColor Cyan
    $confirmation = Read-Host "Deseja remover este comando do histórico? (S/N)"

    if ($confirmation -match '^[Ss]$') {
        # Remover o comando do histórico
        $historyPath = (Get-PSReadlineOption).HistorySavePath
        $history = Get-Content $historyPath

        # Filtrar e salvar novamente sem o último comando
        $newHistory = $history | Where-Object { $_ -ne $lastCommand.CommandLine }
        $newHistory | Set-Content $historyPath

        Write-Host "Comando removido do histórico." -ForegroundColor Green
    } else {
        Write-Host "Ação cancelada." -ForegroundColor Yellow
    }
}

# Executar a função automaticamente
Remove-LastHistory
