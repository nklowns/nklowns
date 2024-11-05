param (
    [string]$branchType, # "bugfix" ou "feature"
    [string]$task # Exemplo de entrada: "[#86a57xe86] - [Refinar] Alterar labels de PDI para PDP"
)

function Parse-task {
    param (
        [string]$info
    )

    if ($info -match "\[#([a-zA-Z0-9]+)(?:[:-](\d+))?\] - (.+)") {
        return [PSCustomObject]@{
            taskID = $matches[1]
            version = if ($matches[2]) { [int]$matches[2] } else { 0 }
            taskName = $matches[3]
        }
    } else {
        throw "Formato da task inválido."
    }
}

function Get-LastTaskVersion {
    param (
        [string]$taskID
    )

    $commits = git log --oneline --format="%s" --grep="#$taskID" | Select-String -Pattern "\[#${taskID}(?:[:-](\d+))?\]"

    if ($commits) {
        $versions = $commits.Matches | ForEach-Object { if ($_.Groups[1].Success) { [int]$_.Groups[1].Value } else { 0 } } | Sort-Object -Descending
        return $versions[0] + 1
    } else {
        return 0
    }
}

function Create-Branch {
    param (
        [PSCustomObject]$task
    )

    if ($branchType -notin @("bugfix", "feature", "hotfix")) {
        return
    }

    $branchName = "${branchType}/$($task.taskID)"
    if ($task.version -gt 0) {
        $branchName += "-$($task.version)"
    }

    git checkout -b $branchName origin/develop
    git push --no-verify --set-upstream origin $branchName
    Write-Output "Branch criada: ${branchName}"
}

function Create-Commit {
    param (
        [PSCustomObject]$task
    )

    $commitMessage = if ($task.version -eq 0) { "[#$($task.taskID)] - $($task.taskName)" } else { "[#$($task.taskID):$($task.version)] - $($task.taskName)" }
    git commit --no-edit --allow-empty -m $commitMessage
    Write-Output "Commit criado: ${commitMessage}"
}

$taskDetails = if ($task) { Parse-task -info $task } else { Parse-task -info (git log --oneline --reverse -1) }
$lastVersion = Get-LastTaskVersion -taskID $taskDetails.taskID
$taskDetails.version = $lastVersion

Create-Branch -task $taskDetails
Create-Commit -task $taskDetails
