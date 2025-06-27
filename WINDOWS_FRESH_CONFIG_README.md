# Primeiros passos para trilha

Atualizar todo o sistema! (Obviamente)

Skip-to:
- [Gerenciamento de Terminal](#gerenciamento-de-terminal)
- [Gerenciador de Pacotes](#gerenciador-de-pacotes)
- [Configurando o terminal](#configurando-o-terminal)
- [Configurando o git](#configurando-o-git)
- [Configurando as JDKs](#configurando-as-jdks)

## Gerenciamento de Terminal

Instalar o [Terminal do Windows](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701?hl=pt-br&gl=br), provavelmente já vem instalado por padrão.

Instalar o [Powershell 7](https://learn.microsoft.com/pt-br/powershell/scripting/install/installing-powershell-on-windows):

```ps1
winget install --id Microsoft.Powershell --source winget
```

## Gerenciador de Pacotes

Instalar o melhor gerenciador (~~que não é o chocolatey~~)

[Scoop.sh](https://scoop.sh/):
```ps1
# Optional: Needed to run a remote script the first time
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

irm get.scoop.sh -outfile 'install.ps1'

.\install.ps1 -ScoopDir 'C:\Scoop' -ScoopGlobalDir 'C:\GlobalScoopApps' -NoProxy
```

### Lista de aplicativos para fresh start do scoop

#### Pacotes Local

```sh
scoop install nssm git curl ngrok openssl ffmpeg imagemagick yt-dlp adb scrcpy
```

#### Buckets para scoop

> nerd-fonts

```sh
scoop bucket add nerd-fonts
```

#### Pacotes Global

> FiraCode-NF

```sh
sudo scoop install -g FiraCode-NF
```

## Configurando o terminal

#### Instalar o [OhMyPosh.dev](https://ohmyposh.dev/)

```ps1
winget install --id JanDeDobbeleer.OhMyPosh --source winget
```

#### Instalar o Terminal-Icons

```ps1
Install-Module -Name Terminal-Icons -Repository PSGallery
```

#### Iniciar o $PROFILE do terminal atual

```ps1
New-Item -Path $PROFILE -Type File -Force
```

Baixar o [arquivo de layout para ohmyposh](assets/nks.omp.json), para extrair no diretorio ao lado do $PROFILE
`~/Documents/PowerShell/nks.omp.json`

```ps1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/nklowns/nklowns/main/assets/nks.omp.json" -OutFile "$env:USERPROFILE\Documents\PowerShell\nks.omp.json"
```

Baixar o [arquivo de configuração do powershell](assets/Microsoft.PowerShell_profile.ps1), para substituir o conteudo do $PROFILE
`~/Documents/PowerShell/profile.ps1` ou `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`

```ps1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/nklowns/nklowns/main/assets/Microsoft.PowerShell_profile.ps1" -OutFile "$env:USERPROFILE\Documents\PowerShell\profile.ps1"
```

## Configurando o git

#### Configuração para ssh-agent

```ps1
Set-Service ssh-agent -StartupType Automatic
```

#### .gitconfig

Baixar o exemplo do [arquivo de configuração do git](assets/.gitconfig), esse arquivo ira substituir o escopo global de configurações: `~/.gitconfig`

```ps1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/nklowns/nklowns/main/assets/.gitconfig" -OutFile "$env:USERPROFILE\.gitconfig"

git config --global -e
```

#### Configuração especifica para um Ambiente/Worktree de git

Baixar o [arquivo de config para worktree](assets/.gitconfig_include), esse arquivo `.gitconfig_include` ira substituir o escopo da pasta relativa que foi definido nas configurações do git:

```md
[includeIf "gitdir:**/<WORKTREE>/"]
  path = C:/<WORKTREE>/.gitconfig_include
```

Subistituir a identificação de pasta relativa &lt;WORKTREE&gt;

Alocar o arquivo `.gitconfig_include` no diretorio &lt;WORKTREE&gt; utilizado, e atualizar o path para o caminho absoluto do mesmo.

## Configurando as JDKs

Utilizando os binarios da [Adoptium.net](https://adoptium.net/installation/).

```ps1
winget install EclipseAdoptium.Temurin.8.JDK
winget install EclipseAdoptium.Temurin.11.JDK
winget install EclipseAdoptium.Temurin.17.JDK
```


Executar o [arquivo de syslink para Temurin](assets/EclipseAdoptium.Temurin.JDK.ps1).

## Configurando o Node

Utilizando o Fnm [fnm.vercel.app](https://github.com/Schniz/fnm).

```ps1
winget install Schniz.fnm
```

## Configurando o Defender

```ps1
Set-MpPreference -ScanAvgCPULoadFactor 23
```
