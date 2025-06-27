# Expor docker daemon
$ip = (Get-NetIPAddress -InterfaceAlias "Tailscale" -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress
if ($ip) {
    netsh interface portproxy delete v4tov4 listenport=2375 listenaddress=$ip
    netsh interface portproxy add v4tov4 listenport=2375 listenaddress=$ip connectaddress=127.0.0.1 connectport=2375
    Write-Host "Portproxy configurado para $ip"
}

# Executar como ADMINISTRADOR
Write-Host "🔧 Ajustando range de portas dinâmicas para evitar conflito com Docker..."
netsh int ipv4 set dynamicportrange tcp start=10000 num=55535


# Lista de portas a reservar
$portas = @(
    6006,8000,9001,9010,9020,9030,9040,9050,9060,9070,9080,9090,
    12690,3000,4000,5000,
    15672,5672,
    27017
)

foreach ($porta in $portas) {
    $rangeExiste = netsh interface ipv4 show excludedportrange protocol=tcp | Select-String "$porta"
    if (-not $rangeExiste) {
        Write-Host "➕ Reservando porta $porta..."
        netsh interface ipv4 add excludedportrange protocol=tcp startport=$porta numberofports=1
    } else {
        Write-Host "✔ Porta $porta já está reservada. Pulando..."
    }
}

Write-Host "✅ Todas as portas reservadas com sucesso."