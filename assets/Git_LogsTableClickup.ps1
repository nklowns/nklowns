param(
    [string]$branchA = "develop",
    [string]$branchB = "master",
    $listarTasks = $false
)

function Get-ClickupTasks {
    param (
        [string]$branch,
        # Filtrar os commits de task pelo padrão "[#taskID:version]"
        [string]$taskPattern = "\[#([a-zA-Z0-9]+)(?:[:-](\d+))?\] -?(.+)",
        # Ignorar os commits de configuração do ambiente no milestone-sandbox (ajuste se você deseja)
        [string]$ignorePattern = "produção|Sandbox"
    )

    # Obtenha os commits da milestone-production (status: entregue) e filtre por padrão
    $commits = git log $branch --oneline --pretty=format:"%h|%ad|%s|%an" --date=format:'%Y-%m-%d %H:%M:%S' |
               Select-String -Pattern $taskPattern |
               Where-Object { $_.Line -notmatch $ignorePattern }

    if (-not $commits) {
        Write-Host "Nenhum commit encontrado na branch $branch."
        return @()
    }

    # Extrair detalhes dos commits
    $tasks = $commits.Line | ForEach-Object {
        $commitDetails = $_.Split('|')
        $taskMatches = [regex]::Matches($_, $taskPattern)

        $taskMatches | ForEach-Object {
            $version = if ($_.Groups[2].Success) { [int]$_.Groups[2].Value } else { 0 }

            [PSCustomObject]@{
                TaskID        = $_.Groups[1].Value
                Version       = $version
                CommitHash    = $commitDetails[0]
                CommitDate    = [datetime]$commitDetails[1]
                CommitMessage = $commitDetails[2]
                Author        = $commitDetails[3]
            }
        }
    }

    Write-Host "Tarefas encontradas ($($branch)): $($tasks.Count)"

    # Ordenar as tasks válidas pela taskID e data do commit (mais recente primeiro)
    return $tasks | Sort-Object -Property @{Expression="TaskID";Descending=$false}, @{Expression="CommitDate";Descending=$true}
}

function Compare-TasksVersions {
    param(
        [array]$tasksA,
        [array]$tasksB,
        [string]$branch
    )

    # Create a lookup table for the maximum version of each task in branchB
    $maxVersionsBranchB = [hashtable]::Synchronized(@{})
    foreach ($task in $tasksB) {
        $maxVersionsBranchB[$task.TaskID] = [math]::Max($maxVersionsBranchB[$task.TaskID], $task.Version)
    }

    # Identify tasks that are only in branchA or have a higher version
    $tasksOnBranchAOnly = $tasksA | Where-Object { $maxVersionsBranchB[$_.TaskID] -lt $_.Version }

    if ($tasksOnBranchAOnly) {
        Write-Host "`nTarefas que estão pendentes ($($branch)): $($tasksOnBranchAOnly.Count)"
    }

    return $tasksOnBranchAOnly
}

function Write-Table {
    param(
        [string]$branchA,
        [string]$branchB,
        [array]$tasks
    )

    if (-not $tasks) {
        return
    }

    # Exibir a lista de tasks válidas no terminal
    $taskCount = $tasks.Count
    Write-Host "`nBranch: $branchA -> $branchB"

    # Usar um hash table para rastrear IDs únicos e versões que faltam
    $tasksPresented = @{}
    $tasks | ForEach-Object {
        try {
            # Write-Host "Processando task: $_.CommitMessage"  # Depuração para verificar a task

            $taskID = $_.TaskID
            $commitMessage = $_.CommitMessage
            $url = "https://app.clickup.com/t/$taskID"

            $currentVersion = $_.Version
            $commitDate = $_.CommitDate.ToString('dd/MM/yyyy HH:mm:ss')
            $author = $_.Author
            $versionUnique = "$currentVersion ($commitDate)"

            $notListed = $tasksPresented.ContainsKey($taskID)
            # Adiciona apenas se o taskID não estiver no hash table
            if (-not $notListed -or -not $tasksPresented[$taskID].Contains($versionUnique)) {
                # Inicializa a lista de versões e datas
                $tasksPresented[$taskID] = @()
                $tasksPresented[$taskID] += $versionUnique
            }

            if ($listarTasks) {
                if (-not $notListed) {
                    Write-Host "$url"
                }

                return
            }

            if (-not $notListed) {
                $count = $tasksOnBranchAOnly | Where-Object { $_.TaskID -eq $taskID } | Measure-Object | Select-Object -ExpandProperty Count
                Write-Host "`n---- $taskID [$count] ----"
            }
            Write-Host "$versionUnique | $author | $url | $commitMessage | $($_.CommitHash)"
        }
        catch {
            Write-Error "Erro ao processar uma task: $_"
        }
    }

    Write-Host "`nTabela de tasks ($taskCount commits) ($($tasksPresented.Count) tasks)"
}

# Extraia os taskIDs, versões, mensagens e author dos commits da milestone-sandbox
$tasksBranchA = Get-ClickupTasks -branch $branchA
$tasksBranchB = Get-ClickupTasks -branch $branchB

# Comparar as tasks e identificar tarefas pendentes
$tasksOnBranchAOnly = Compare-TasksVersions -tasksA $tasksBranchA -tasksB $tasksBranchB -branch $branchA
# Cria uma tabela de tarefas pendentes
$presentedTableA = Write-Table -tasks $tasksOnBranchAOnly -branchA $branchA -branchB $branchB

# Comparar as tasks e identificar tarefas exclusivas
$tasksOnBranchBOnly = Compare-TasksVersions -tasksA $tasksBranchB -tasksB $tasksBranchA -branch $branchB
# Cria uma tabela de tarefas exclusivas
$presentedTableB = Write-Table -tasks $tasksOnBranchBOnly -branchA $branchB -branchB $branchA

# Opcional: Salvar a lista em um arquivo de log (descomente se desejar)
# $uniqueTasks.GetEnumerator() | ForEach-Object {
#     $taskID = $_.Key
#     $commitMessage = $_.Value
#     $url = "https://app.clickup.com/t/$taskID"
#     "$url | $commitMessage"
# } | Out-File "valid_tasks_list.txt"
