Instalar
```pwsh
winget install npiperelay

scoop install gpg
git config --global gpg.program "C:\Scoop\apps\gpg\current\bin\gpg2.exe"
```

Testar
```pwsh
gpg-connect-agent killagent /bye
gpg-connect-agent /bye
Get-Process | Where-Object { $_.Name -like "gpg*" }
Get-ChildItem -Path \\.\pipe\ | Where-Object { $_.Name -like "*gpg*" }
```

Service
```pwsh
$GpgPath=(scoop which gpg-connect-agent).Trim();
$StartupPath="$([Environment]::GetFolderPath('Startup'))\Start GPG Agent.lnk";
$Shell=New-Object -ComObject WScript.Shell;
$Shortcut=$Shell.CreateShortcut($StartupPath);
$Shortcut.TargetPath=$GpgPath;
$Shortcut.Arguments='/bye';
$Shortcut.WorkingDirectory=(Split-Path $GpgPath);
$Shortcut.WindowStyle=1;
$Shortcut.IconLocation="$GpgPath,0";
$Shortcut.Description='Start GPG Agent at Startup';
$Shortcut.Save();
```

wsl ~/.bashrc
```sh
# --- Ponte para Agentes do Windows (SSH e GPG) ---

# Encontra o npiperelay.exe no PATH do Windows
# Certifique-se de que o diretório do npiperelay.exe está no seu PATH do Windows
NPIPERELAY_PATH=$(which npiperelay.exe)

# Configura o GPG para funcionar corretamente no terminal
export GPG_TTY=$(tty)

if [ -n "$NPIPERELAY_PATH" ]; then

    # --- Configuração do Agente SSH ---
    export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
    if ! ss -a | grep -q $SSH_AUTH_SOCK; then
        rm -f $SSH_AUTH_SOCK
        # Inicia a ponte socat para o ssh-agent em background
        (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$NPIPERELAY_PATH -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
    fi

    # --- Configuração do Agente GPG ---
    # O GPG no Linux espera encontrar os soquetes dentro de ~/.gnupg
    GNUPG_DIR="$HOME/.gnupg"
    mkdir -p "$GNUPG_DIR" && chmod 700 "$GNUPG_DIR"

    # Define os soquetes do GPG
    GPG_AGENT_SOCK="$GNUPG_DIR/S.gpg-agent"
    GPG_AGENT_EXTRA_SOCK="$GNUPG_DIR/S.gpg-agent.extra"
    GPG_AGENT_BROWSER_SOCK="$GNUPG_DIR/S.gpg-agent.browser"
    GPG_AGENT_SSH_SOCK="$GNUPG_DIR/S.gpg-agent.ssh"

    # Gpg4win expõe o agente GPG através de um named pipe.
    # Criamos a ponte para cada soquete que o GPG possa precisar.
    if ! ss -a | grep -q $GPG_AGENT_SOCK; then
        rm -f $GPG_AGENT_SOCK
        (setsid socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:"$NPIPERELAY_PATH -ei -s //./pipe/gpg-agent",nofork &) >/dev/null 2>&1
    fi
    if ! ss -a | grep -q $GPG_AGENT_EXTRA_SOCK; then
        rm -f $GPG_AGENT_EXTRA_SOCK
        (setsid socat UNIX-LISTEN:$GPG_AGENT_EXTRA_SOCK,fork EXEC:"$NPIPERELAY_PATH -ei -s //./pipe/gpg-agent-extra",nofork &) >/dev/null 2>&1
    fi
    if ! ss -a | grep -q $GPG_AGENT_BROWSER_SOCK; then
        rm -f $GPG_AGENT_BROWSER_SOCK
        (setsid socat UNIX-LISTEN:$GPG_AGENT_BROWSER_SOCK,fork EXEC:"$NPIPERELAY_PATH -ei -s //./pipe/gpg-agent-browser",nofork &) >/dev/null 2>&1
    fi
    if ! ss -a | grep -q $GPG_AGENT_SSH_SOCK; then
        rm -f $GPG_AGENT_SSH_SOCK
        (setsid socat UNIX-LISTEN:$GPG_AGENT_SSH_SOCK,fork EXEC:"$NPIPERELAY_PATH -ei -s //./pipe/gpg-agent-ssh",nofork &) >/dev/null 2>&1
    fi

else
    echo "AVISO: npiperelay.exe não encontrado no PATH. A ponte para SSH/GPG não funcionará."
fi
```
