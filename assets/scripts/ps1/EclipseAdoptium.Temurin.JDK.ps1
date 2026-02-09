# Caminho base para a instalação do Eclipse Adoptium
$eclipseInstallPath = "C:\Program Files\Eclipse Adoptium"
$latestLTS = "25"

# Verifica se o Eclipse Adoptium Temurin JDK está instalado via winget
$eclipseJdk = (winget list | Select-String -Pattern "EclipseAdoptium.Temurin.$latestLTS.JDK").Matches.Value

# Verifica se o JDK já está instalado
if ($eclipseJdk -eq $null) {
    Write-Host "Eclipse Adoptium Temurin JDK não encontrado."
    exit
}

# Determina a versão do JDK instalada
$jdkPath = (Get-ChildItem $eclipseInstallPath | Where-Object { $_.Name -like "jdk-$latestLTS.*-hotspot" } | Sort-Object -Property CreationTime -Descending | Select-Object -First 1).FullName

if ($jdkPath -eq $null) {
    Write-Host "Nenhuma versão do JDK encontrada em '$eclipseInstallPath'."
    exit
}

# Define o caminho para o symlink
$symlinkPath = Join-Path -Path $eclipseInstallPath -ChildPath "default"

# Verifica se o symlink já existe
if (Test-Path $symlinkPath) {
    # Remove o symlink existente
    try {
        Remove-Item $symlinkPath -ErrorAction Stop
        Write-Host "Symlink antigo removido."
    }
    catch {
        Write-Host "Erro ao remover symlink antigo: $_"
        exit
    }
}

# Cria o symlink
try {
    New-Item -ItemType SymbolicLink -Path $symlinkPath -Target $jdkPath -ErrorAction Stop
    Write-Host "Symlink criado com sucesso em '$symlinkPath', apontando para '$jdkPath'."
}
catch {
    Write-Host "Erro ao criar symlink: $_"
    exit
}
