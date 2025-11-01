# Instalar

```pwsh
Add-WindowsCapability -Online -Name OpenSSH.Server

Set-Service ssh-agent -StartupType Automatic
Set-Service sshd -StartupType Automatic
# C:\ProgramData\ssh\logs\sshd.log
```

# Testar
```pwsh
Get-Service sshd
Test-NetConnection -ComputerName localhost -Port 22
```

Path
```pwsh
Get-CimInstance Win32_Directory -Filter 'Name="C:\\Program Files"' | Select-Object EightDotThreeFileName
```


## Definition
```pwsh
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $(Get-Command pwsh.exe).Source -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShellCommandOption -Value "" -PropertyType String -Force

Set-ItemProperty -Verbose -Path "HKLM:\SOFTWARE\OpenSSH" -Name "DefaultShell" -Value ($(Get-Command pwsh.exe).Source -replace 'C:\\Program Files', (Get-CimInstance Win32_Directory -Filter 'Name="C:\\Program Files"').EightDotThreeFileName)

New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name "DefaultShell" -Value (Join-Path -Path (Get-Location) -ChildPath "pwsh.bat") -PropertyType String -Force
```


## Override
```pwsh
Copy-Item -Path "C:\ProgramData\ssh\sshd_config" -Destination "C:\ProgramData\ssh\sshd_config.bak"
Copy-Item -Path "D:\nklowns\nklowns\openSSH\sshd_config" -Destination "C:\ProgramData\ssh\sshd_config" -Force

icacls "C:\ProgramData\ssh\sshd_config" /reset
icacls "C:\ProgramData\ssh\sshd_config" /inheritance:r
icacls "C:\ProgramData\ssh\sshd_config" /grant "*S-1-5-18:(R)" "*S-1-5-32-544:(R)"

Restart-Service sshd
```


## Syslink
```pwsh
Rename-Item -Path "C:\ProgramData\ssh\sshd_config" -NewName "sshd_config.bak"
New-Item -ItemType SymbolicLink -Path "C:\ProgramData\ssh\sshd_config" -Target "D:\nklowns\nklowns\openSSH\sshd_config"

icacls "D:\nklowns\nklowns\openSSH\sshd_config" /reset
icacls "D:\nklowns\nklowns\openSSH\sshd_config" /inheritance:r
icacls "D:\nklowns\nklowns\openSSH\sshd_config" /grant "*S-1-5-18:(R)" "*S-1-5-32-544:(R)"

Restart-Service sshd
```

