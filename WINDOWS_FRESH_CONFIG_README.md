# Primeiros passos para trilha

Atualizar todo o sistema! (Obviamente)

Skip-to:
- [Gerenciamento de Terminal](#gerenciamento-de-terminal)
- [Gerenciador de Pacotes](#gerenciador-de-pacotes)
- [Configurando o terminal](#configurando-o-terminal)
- [Configurando o git](#configurando-o-git)
- [Configurando as JDKs](#configurando-as-jdks)

## Gerenciamento de Terminal

Instalar o [Terminal do Windows](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701?hl=pt-br&gl=br)
<br>provavelmente já vem instalado por padrão.

Instalar o [Powershell 7](https://learn.microsoft.com/pt-br/powershell/scripting/install/installing-powershell-on-windows)

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code style="line-height: 1.4; font-size: 0.9em; margin: 0px; white-space: pre;"><span class="token" style="color: rgb(255, 215, 0);">winget install</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">--id</span><span> </span><span>Microsoft.Powershell</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">--source</span><span> </span><span>winget</span></code>
</pre>
<br>

## Gerenciador de Pacotes

Instalar o gerenciador que não é o chocolatey

[Scoop.sh](https://scoop.sh/)

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code style="line-height: 1.4; font-size: 0.9em; margin: 0px; white-space: pre;"><span class="token" style="color: rgb(255, 215, 0);">Set-ExecutionPolicy</span><span> RemoteSigned </span><span class="token" style="color: rgb(0, 224, 224);">-</span><span>Scope CurrentUser </span><span class="token" style="color: rgb(212, 208, 171);"># Optional: Needed to run a remote script the first time</span><span>
</span><span class="token" style="color: rgb(255, 215, 0);">irm</span><span> get</span><span class="token" style="color: rgb(254, 254, 254);">.</span><span>scoop</span><span class="token" style="color: rgb(254, 254, 254);">.</span><span>sh </span><span class="token" style="color: rgb(0, 224, 224);">-</span><span>outfile </span><span class="token" style="color: rgb(0, 224, 224);">'install.ps1'</span>
<span class="token" style="color: rgb(255, 215, 0);">.\install.ps1</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">-</span><span>ScoopDir </span><span class="token" style="color: rgb(0, 224, 224);">'C:\Scoop'</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">-</span><span>ScoopGlobalDir </span><span class="token" style="color: rgb(0, 224, 224);">'C:\GlobalScoopApps'</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">-</span><span>NoProxy</span></code>
</pre>
<br>

### Lista de aplicativos para fresh start do scoop

#### Pacotes Local

> git
> sudo
> curl

> ngrok
> openssl

> ffmpeg
> imagemagick
> yt-dlp

> adb
> scrcpy

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code style="line-height: 1.4; font-size: 0.9em; margin: 0px; white-space: pre;"><span class="token" style="color: rgb(255, 215, 0);">scoop install</span><span> git</span><span> sudo</span><span> curl</span><span> ngrok</span><span> openssl</span><span> ffmpeg</span><span> imagemagick</span><span> yt-dlp</span><span> adb</span><span> scrcpy</span></code>
</pre>
<br>

#### Buckets para scoop

> nerd-fonts

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code style="line-height: 1.4; font-size: 0.9em; margin: 0px; white-space: pre;"><span class="token" style="color: rgb(255, 215, 0);">scoop bucket</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">add</span><span> nerd-fonts</span></code>
</pre>
<br>

#### Pacotes Global

> FiraCode-NF

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code style="line-height: 1.4; font-size: 0.9em; margin: 0px; white-space: pre;"><span class="token" style="color: rgb(255, 215, 0);">sudo scoop install</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">-g</span><span> FiraCode-NF</span></code>
</pre>
<br>

## Configurando o terminal

Instalar o [OhMyPosh.dev](https://ohmyposh.dev/)

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code style="line-height: 1.4; font-size: 0.9em; margin: 0px; white-space: pre;"><span class="token" style="color: rgb(255, 215, 0);">winget install</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">--id</span><span> </span><span>JanDeDobbeleer.OhMyPosh</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">--source</span><span> </span><span>winget</span></code>
</pre>
<br>

Instalar o Terminal-Icons

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code style="line-height: 1.4; font-size: 0.9em; margin: 0px; white-space: pre;"><span class="token" style="color: rgb(255, 215, 0);">Install-Module</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">-Name</span><span> Terminal-Icons</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">-Repository</span><span> PSGallery</span></code>
</pre>
<br>

Iniciar o $PROFILE do terminal atual<br>
Cuidado com o <span class="token" style="color: rgb(0, 224, 224);">-Force</span>

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code style="line-height: 1.4; font-size: 0.9em; margin: 0px; white-space: pre;"><span class="token" style="color: rgb(255, 215, 0);">New-Item</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">-Path</span><span> $PROFILE</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">-Type</span><span> File</span><span> </span><span class="token" style="color: rgb(0, 224, 224);">-Force</span></code>
</pre>
<br>

### $PROFILE

Baixar o [arquivo de layout para ohmyposh](assets/nks.omp.json)
<br>
Extrair no diretorio ao lado do $PROFILE no caso do Windows
`~/Documents/PowerShell/nks.omp.json`

Editar a [configuração do powershell](assets/Microsoft.PowerShell_profile.ps1) para o seguinte conteudo
<br>

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code><span>oh-my-posh init pwsh --config="~/Documents/PowerShell/nks.omp.json" | Invoke-Expression</span>

<span>Import-Module -Name Terminal-Icons</span></code>
</pre>
<br>

## Configurando o git

Baixar o [arquivo de config para git](assets/.gitconfig)

Esse arquivo ira substituir o escopo global de configurações
``` 
SCOPES global
$XDG_CONFIG_HOME/git/config

~/.gitconfig
```

Abrimos o arquivo para visualização e edição rapida seguindo

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code><span>git config --global core.editor notepad</span>
<span>git config --global -e</span></code>
</pre>
<br>

### configuração especifica para um Ambiente/Worktree de git

Baixar o [arquivo de config para worktree](assets/.gitconfig_include)

Esse arquivo ira substituir o escopo da pasta relativa que foi utilizada nas configurações do git
```
[includeIf "gitdir:**/<WORKTREE>/"]
  path = C:/<WORKTREE>/.gitconfig_include
```
Subistituir a identificação de pasta relativa &lt;WORKTREE&gt;

Alocar o arquivo no diretorio &lt;WORKTREE&gt; utilizado, e atualizar o path para o caminho absoluto do mesmo.

## Configurando as JDKs

Utilizando os binarios da [Adoptium.net](https://adoptium.net/installation/)

<pre style="color: rgb(248, 248, 242); background: rgb(43, 43, 43); font-family: Consolas, Monaco, &quot;Andale Mono&quot;, &quot;Ubuntu Mono&quot;, monospace; text-align: left; white-space: pre; word-spacing: normal; word-break: normal; overflow-wrap: normal; line-height: 1.4; tab-size: 4; hyphens: none; padding: 1em; margin: 0px; overflow: auto; border-radius: 0.3em; font-size: 0.9em;">
<code style="line-height: 1.4; font-size: 0.9em; margin: 0px; white-space: pre;"><span class="token" style="color: rgb(255, 215, 0);">winget install</span><span> EclipseAdoptium.Temurin.8.JDK</span>
<span class="token" style="color: rgb(255, 215, 0);">winget install</span><span> EclipseAdoptium.Temurin.11.JDK</span>
<span class="token" style="color: rgb(255, 215, 0);">winget install</span><span> EclipseAdoptium.Temurin.17.JDK</span></code>
</pre>
<br>

## Configurando o Node

Utilizando o Volta [volta.sh](https://volta.sh/)
