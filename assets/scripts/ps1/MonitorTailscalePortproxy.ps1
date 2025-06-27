<#
    Script: MonitorTailscalePortproxy.ps1
    Propósito: Monitora a interface Tailscale e configura netsh portproxy assim que o IP IPv4 aparecer.
    Detalhes:
      • Se o IP já estiver ativo, remove e recria a regra.
      • Se o IP mudar (ex: reconexão Tailscale), o loop detecta e atualiza.
      • Executar em loop infinito, com checagem a cada 10 segundos.
#>

# Nome da interface Tailscale (confira em "Get-NetAdapter" ou "ipconfig")
$interfaceAlias = "Tailscale"

# Porta que queremos redirecionar
$listenPort       = 2375
$connectAddress   = "127.0.0.1"
$connectPort      = 2375

# Função que busca o IP IPv4 na interface Tailscale
function Get-TailscaleIPv4 {
    try {
        $addr = Get-NetIPAddress `
            -InterfaceAlias $interfaceAlias `
            -AddressFamily IPv4 `
            -ErrorAction Stop |
            Select-Object -ExpandProperty IPAddress
        return $addr
    } catch {
        return $null
    }
}

# Função para (re)configurar o portproxy
function Configure-Portproxy {
    param (
        [string]$listenIP
    )
    # Deletar qualquer regra existente para esse listenIP/porta
    netsh interface portproxy delete v4tov4 `
        listenport=$listenPort `
        listenaddress=$listenIP | Out-Null

    # Adicionar a nova regra
    netsh interface portproxy add v4tov4 `
        listenport=$listenPort `
        listenaddress=$listenIP `
        connectaddress=$connectAddress `
        connectport=$connectPort | Out-Null

    # Opcional: Log para evento de aplicação ou arquivo de texto
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $msg = "$timestamp - Configurado portproxy: [$listenIP]:$listenPort → $connectAddress:$connectPort"
    # Exemplo de log em arquivo (pode ajustar caminho)
    $logFile = "C:\Logs\MonitorTailscalePortproxy.log"
    if (!(Test-Path (Split-Path $logFile))) {
        New-Item -ItemType Directory -Path (Split-Path $logFile) -Force | Out-Null
    }
    Add-Content -Path $logFile -Value $msg
}

# Loop principal
while ($true) {
    $currentIP = Get-TailscaleIPv4
    if ($currentIP) {
        # Se existir IP e não for igual ao último configurado, atualiza
        if ($global:LastIP -ne $currentIP) {
            $global:LastIP = $currentIP
            Configure-Portproxy -listenIP $currentIP
        }
    } else {
        # Se não encontrou IP e havia um último configurado, limpar variáveis
        if ($global:LastIP) {
            $global:LastIP = $null
            # Opcional: poderia remover a regra, mas portproxy sem IP não faz nada
        }
    }
    Start-Sleep -Seconds 10
}
