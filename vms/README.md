```pwsh
irm https://get.activated.win | iex

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

Set-Service ssh-agent -StartupType Automatic

Get-MpPreference | select ScanAvgCPULoadFactor
Set-MpPreference -ScanAvgCPULoadFactor 25

Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Repair-WinGetPackageManager

winget install -e --id Microsoft.WindowsTerminal # Windows Terminal
winget install -e --id Microsoft.PowerShell # PowerShell 7
winget install -e --id 9MSMLRH6LZF3 # Notepad

winget install -e --id MongoDB.Shell # MongoDB Shell
```


```pwsh
net use Z: "\\vmware-host\Shared Folders" /persistent:yes

# Copiar para a pasta de inicialização do Windows
# vms/mount_dev.bat > shell:startup

[Docker_netsh.ps1](../assets/scripts/ps1/Docker_netsh.ps1)
```

```pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install docker-cli
docker context create docker-tower --description "Tailscale" --docker "host=tcp://proxy-traefik.drake-ayu.ts.net:2375"
```


```pwsh
# Caminho da chave do registro para o PowerShell
$powerShellRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

# Atualize a chave para o PowerShell 7
Set-ItemProperty -Path $powerShellRegistryPath -Name "PowerShell" -Value "C:\Program Files\PowerShell\7\pwsh.exe"

Write-Host "O PowerShell 7 foi configurado como o shell padrão no sistema."

# Caminho para a chave de registro que controla o PowerShell 5.1 no Console
$registryPathPS = "HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\powershell.exe"

# Alterar o caminho do PowerShell 5.1 para o PowerShell 7
Set-ItemProperty -Path $registryPathPS -Name "(Default)" -Value "C:\Program Files\PowerShell\7\pwsh.exe"
```