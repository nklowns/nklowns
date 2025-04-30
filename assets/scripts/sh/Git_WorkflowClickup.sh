#!/bin/bash
# Git_WorkflowClickup.sh
# Script para extrair informações de uma task do ClickUp e criar branch e commit
# Fluxo:
# 1 - Sem parâmetro: extrai a task a partir do último commit.
# 2 - Com task_id: consulta a API do ClickUp e obtém o título da task.
#
# Requisitos: curl, jq, git

# Token de acesso à API do ClickUp (hardcoded)
API_TOKEN="<token>"

# Função para validar a existência de dependências necessárias
check_dependencies() {
  for cmd in curl jq git; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Erro: o comando '$cmd' não foi encontrado. Instale-o e tente novamente." >&2
      exit 1
    fi
  done
}

# Função para extrair (parsear) a task a partir de uma string no formato:
# "[#<task_id>]" ou "[#<task_id>:<versão>] - <título>"
parse_task() {
  local info="$1"
  local task_pattern="^\[#?([a-zA-Z0-9]+)([:-]([0-9]+))?\][[:space:]-]*(.+)$"
  # local task_pattern="^\[#([a-zA-Z0-9]+)([:-]([0-9]+))?\][ -]*(.+)$"

  if [[ $info =~ $task_pattern ]]; then
    task_id="${BASH_REMATCH[1]}"
    version="${BASH_REMATCH[3]:-0}"
    task_name="${BASH_REMATCH[4]}"
    echo "$task_id|$version|$task_name"
  else
    echo "Formato da task inválido: $info" >&2
    echo "Padrão esperado: [#<task_id>] - <título> ou [#<task_id>:<versão>] - <título>" >&2
    exit 1
  fi
}

# Função para consultar a API do ClickUp e obter os detalhes da task.
# Retorna a string no formato "[#<task_id>] - <título>"
get_task_details() {
  local task_id="$1"
  local response
  response=$(curl -s -H "Authorization: $API_TOKEN" "https://api.clickup.com/api/v2/task/$task_id")
  # Utiliza jq para extrair o título da task
  local title
  title=$(echo "$response" | jq -r '.name')

  if [[ -z "$title" || "$title" == "null" ]]; then
    echo "Erro: não foi possível obter o título da task $task_id" >&2
    exit 1
  fi
  echo "[#$task_id] - $title"
}

# Função para obter o último commit (mensagem) que contenha a task
get_last_commit_message() {
  local commit
  commit=$(git log --oneline -1 --format='%s')
  if [[ -z "$commit" ]]; then
    echo "Nenhum commit encontrado para extrair informações." >&2
    exit 1
  fi
  echo "$commit"
}

# Função para calcular a próxima versão da task a partir do histórico de commits
get_last_task_version() {
  local task_id="$1"

  # Busca commits que contenham o identificador da task
  local commits
  # commits=$(git log --oneline --format="%s" --grep="#$task_id")
  commits=$(git log --oneline --format="%s" --grep="\[#${task_id}")

  if [[ -n "$commits" ]]; then
    # Extrai os números de versão presentes no padrão [#task_id:<versão>]
    local versions
    # versions=$(echo "$commits" | grep -oP "\[#${task_id}[:-]?\d+\]" | grep -oP "[:-]\d+" | tr -d ':-' | sort -nr | head -n 1)
    versions=$(echo "$commits" | grep -oP "\[#${task_id}[:-]\K\d+(?=\])" | sort -nr | head -n 1)

    if [[ -n "$versions" ]]; then
      echo $((versions + 1))
    else
      echo 1
    fi
  else
    echo 0
  fi
}

# Função para exibir menu e selecionar o tipo de branch interativamente
select_branch_type() {
  local branch_types=("bugfix" "feature" "hotfix" "no-branch")

  # Exibir opções no stderr para não interferir no retorno da função
  echo >&2 "Insira um número ou pressione <enter> para selecionar o tipo de branch (padrão: '1'):"
  for i in "${!branch_types[@]}"; do
    echo >&2 "$((i + 1)). ${branch_types[$i]}"
  done

  read -r selection
  selection=${selection:-1} # Padrão para 1 (bugfix)

  if [[ "$selection" =~ ^[1-4]$ ]]; then
    echo "${branch_types[$((selection - 1))]}" # Apenas retorna o valor correto
  else
    echo "bugfix"
  fi
}

# Função para criar a branch no Git com base no tipo selecionado e na task
create_branch() {
  local task_id="$1"
  local version="$2"

  local branchType
  branchType="$(select_branch_type)"

  if [[ "$branchType" == "no-branch" ]]; then
    return
  fi

  local branchName="${branchType}/${task_id}"
  if [[ "$version" -gt 0 ]]; then
    branchName="${branchName}-${version}"
  fi

  echo "git checkout -b $branchName origin/develop"
  echo "git push --no-verify --set-upstream origin $branchName"

  # Cria a branch a partir da branch "develop"
  if ! git checkout -b "$branchName" origin/develop; then
    echo "Erro ao criar a branch ${branchName}" >&2
    exit 1
  fi

  # Realiza push da branch
  if ! git push --no-verify --set-upstream origin "$branchName"; then
    echo "Erro ao realizar push da branch ${branchName}" >&2
    exit 1
  fi

  echo "Branch criada com sucesso: $branchName"
}

# Função para criar o commit com a mensagem padronizada
create_commit() {
  local task_id="$1"
  local version="$2"
  local task_name="$3"
  local commitMessage

  if [[ "$version" -eq 0 ]]; then
    commitMessage="[#$task_id] - $task_name"
  else
    commitMessage="[#$task_id:$version] - $task_name"
  fi

  echo "git commit --no-edit --allow-empty -m '$commitMessage'"

  # Cria o commit com a mensagem
  if ! git commit --no-edit --allow-empty -m "$commitMessage"; then
    echo "Erro ao criar commit com a mensagem: ${commitMessage}" >&2
    exit 1
  fi
}

# Função principal que gerencia o fluxo do script
main() {
  check_dependencies

  local raw_task=""
  local taskData=""
  local task_id=""
  local version=""
  local task_name=""

  # Se um parâmetro (task_id) for passado, consulta a API do ClickUp
  if [[ -n "$1" ]]; then
    raw_task=$(get_task_details "$1")
  else
    # Sem parâmetro: extrai a task a partir do último commit
    raw_task=$(get_last_commit_message)
  fi

  # Realiza o parse da task obtida para extrair task_id, versão e título
  taskData=$(parse_task "$raw_task")
  IFS='|' read -r task_id version task_name <<<"$taskData"

  # Atualiza a versão baseado no histórico de commits
  local nextVersion
  nextVersion=$(get_last_task_version "$task_id")
  version="$nextVersion"

  # Cria branch e commit caso haja task_id válido
  if [[ -n "$task_id" ]]; then
    # Exibe o título da task
    echo "/workspace/shared/Git_WorkflowClickup.sh '$task_id'"
    echo "https://app.clickup.com/t/$task_id"

    if [[ -n "$1" ]]; then
      create_branch "$task_id" "$version"
    fi
    create_commit "$task_id" "$version" "$task_name"
  else
    echo "Task_id não identificado." >&2
    exit 1
  fi
}

# Executa o fluxo principal passando os parâmetros (caso haja)
main "$@"
