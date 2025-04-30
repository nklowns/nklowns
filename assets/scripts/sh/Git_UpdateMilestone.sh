#!/bin/bash

update_branch() {
    local branch="$1"
    local shallow="$2"

    echo "---------------- GIT ----------------"
    echo "Atualizando a branch: $branch"

    if ! git rev-parse --verify "$branch" > /dev/null 2>&1; then
        echo "A branch '$branch' não existe localmente. Criando-a a partir de 'origin/$branch'."
        git branch "$branch" "origin/$branch"
    fi

    commits_behind=$(git rev-list "$branch".."origin/$branch" --count)
    if [ "$commits_behind" -gt 0 ]; then
        echo "A branch '$branch' está $commits_behind commit(s) atrás de 'origin/$branch'. Atualizando o ponteiro local..."
        git branch -f "$branch" "origin/$branch"
    fi

    echo "Realizando rebase da branch '$branch' sobre 'origin/develop'..."
    if ! git rebase "origin/develop" "$branch"; then
        echo ">>> CONFLITO detectado no rebase da branch '$branch'. Abortando o rebase..."
        git rebase --abort
        exit 1
    fi

    if [ "$shallow" != "true" ]; then
        commits_to_push=$(git rev-list "origin/$branch".."$branch" --count)
        if [ "$commits_to_push" -gt 0 ]; then
            echo "A branch '$branch' possui $commits_to_push commit(s) novos. Efetuando push..."
            git push --no-verify --force-with-lease origin "$branch"
        else
            echo "Nenhum commit novo na branch '$branch'. Push não necessário."
        fi
    else
        echo "Execução em modo shallow. Push não realizado."
    fi

    echo "---------------- CLICKUP ----------------"
    if [[ "$branch" == *"-engagement" ]]; then
        /workspace/shared/Git_LogsTableClickup.sh "$branch" origin/milestone-production-engagement true
    else
        /workspace/shared/Git_LogsTableClickup.sh "$branch" origin/milestone-production true
    fi
}

main() {
    local shallow="$1"
    local branches=("milestone-sandbox" "milestone-sandbox-engagement")

    git fetch

    for branch in "${branches[@]}"; do
        update_branch "$branch" "$shallow"
    done

    echo "Atualização concluída para todas as branches."
}

main "$@"

