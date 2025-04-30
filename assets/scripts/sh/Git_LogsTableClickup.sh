#!/bin/bash

main() {
    local repoHasMilestoneSandboxEngagementBranch=$(git rev-parse --quiet --verify milestone-sandbox-engagement > /dev/null 2>&1; echo $?)
    if [ $repoHasMilestoneSandboxEngagementBranch -eq 0 ]; then
        local branchA=${1:-"milestone-sandbox-engagement"}
        local branchB=${2:-"milestone-production-engagement"}
    else
        local branchA=${1:-"develop"}
        local branchB=${2:-"master"}
    fi

    local listarTasks=${3:-true}

    local TasksBranchA=$(GetClickupTasks "$branchA")
    local TasksBranchB=$(GetClickupTasks "$branchB")
    local TasksOnBranchAOnly=$(CompareTasksVersions "$TasksBranchA" "$TasksBranchB")
    local TasksOnBranchBOnly=$(CompareTasksVersions "$TasksBranchB" "$TasksBranchA")

    echo -e "/workspace/shared/Git_LogsTableClickup.sh $branchA $branchB true\n"

    local RepoName=$(basename -s .git "$(git remote get-url origin)")
    local LatestTag=$(git describe --tags --abbrev=0 "$branchB")
    echo -e "$RepoName $LatestTag https://bitbucket.org/teamculture/$RepoName/commits/tag/$LatestTag\n"

    WriteTable "$branchA" "$branchB" "$TasksOnBranchAOnly"
    WriteTable "$branchB" "$branchA" "$TasksOnBranchBOnly"
}

GetBranch() {
  local commitHash=$1
  local BranchName=$(git name-rev --name-only $commitHash 2>/dev/null | sed -e 's/origin\///' -e 's/remotes\///')
  local BranchTypes=("bugfix" "feature" "hotfix")

  for BranchType in "${BranchTypes[@]}"; do
    if [[ "$BranchName" == *"$BranchType"* ]]; then
      echo "$BranchType"
      return
    fi
  done

  echo "bugfix"
}

GetClickupTasks() {
    local branch="$1"
    local taskPattern="\[#?([a-zA-Z0-9]+)([:-]([0-9]+))?\][[:space:]-]?*(.+)"
    local ignorePattern="produção|Sandbox"


    # Obter os commits da branch e filtrar pelo padrão de task
    git log "$branch" --oneline --pretty=format:'%h|%ad|%an|%s' --date=format:'%Y-%m-%d %H:%M:%S' | \
        grep -E "$taskPattern" | \
        grep -Ev "$ignorePattern" | \
        while IFS="|" read -r commitHash commitDate author commitMessage; do
            if [[ "$commitMessage" =~ $taskPattern ]]; then
                local taskType="$(GetBranch $commitHash)"
                local taskId="${BASH_REMATCH[1]}"
                local version="${BASH_REMATCH[3]:-0}"
                local taskName="${BASH_REMATCH[4]}"
                echo "$taskId|$version|$commitHash|$commitDate|$commitMessage|$author|$taskType|$taskName"
            fi
        done
}

CompareTasksVersions() {
    local tasksA="$1"
    local tasksB="$2"

    # Declarar array associativo para armazenar as versões máximas de tasks da branch B
    declare -A MaxVersionsBranchB

    # Preencher o array associativo com as versões máximas das tasks da branch B
    while IFS="|" read -r taskId version commitHash commitDate commitMessage author taskType taskName; do
        if [[ -n "$taskId" && -n "$version" ]]; then
            if [[ -z "${MaxVersionsBranchB[$taskId]}" || "${MaxVersionsBranchB[$taskId]}" -lt "$version" ]]; then
                MaxVersionsBranchB["$taskId"]=$version
            fi
        fi
    done <<< "$tasksB"

    # Identificar tasks pendentes na branch A
    result=""
    while IFS="|" read -r taskId version commitHash commitDate commitMessage author taskType taskName; do
        if [[ -n "$taskId" && -n "$version" && ( -z "${MaxVersionsBranchB[$taskId]}" || "${MaxVersionsBranchB[$taskId]}" -lt "$version" ) ]]; then
            result+="$taskId|$version|$commitHash|$commitDate|$commitMessage|$author|$taskType|$taskName"$'\n'
        fi
    done <<< "$tasksA"

    echo "$result"
}

WriteTable() {
    local branchA="$1"
    local branchB="$2"
    local tasks="$3"

    if [[ -n "$tasks" ]]; then
        echo -e "\nBranch: $branchA -> $branchB\n"
    fi

    # Se a opção listarTasks for true, apenas exibe as URLs
    if [ "$listarTasks" == "true" ]; then
        declare -A TaskCommits
        while IFS="|" read -r taskId version commitHash commitDate commitMessage author taskType taskName; do
            if [[ -n "$taskId" ]]; then
                TaskCommits["$taskId"]+="$commitHash "
            fi
        done <<< "$tasks"

        declare -A uniqueTasks
        while IFS="|" read -r taskId version commitHash commitDate commitMessage author taskType taskName; do
            if [[ -n "$taskId" ]]; then
                if [[ -z "${uniqueTasks[$taskId]}" ]]; then
                    uniqueTasks["$taskId"]=1
                    echo "${taskType^} [#$taskId] ($author) - $taskName"
                    echo -e "https://app.clickup.com/t/$taskId ($author)\n"
                    /workspace/shared/Git_GMUD.sh ${TaskCommits[$taskId]}
                    echo -e "\n"
                fi
            fi
        done <<< "$tasks"
    else
        # Exibir detalhes das tasks se listarTasks for false
        while IFS="|" read -r taskId version commitHash commitDate commitMessage author taskType taskName; do
            if [[ -n "$taskId" && -n "$version" ]]; then
                local url="https://app.clickup.com/t/$taskId"
                echo "$url | $author | $taskId | $version | $commitHash"
                echo "$commitMessage"
                echo ""
            fi
        done <<< "$tasks"
    fi
}

main "$@"

