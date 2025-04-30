#!/bin/bash

# Função para obter a lista de arquivos alterados no merge
get_changed_files() {
  local merge_hash=$1
  git -c core.quotepath=off diff --name-only $(git rev-parse "$merge_hash"^) $(git rev-parse "$merge_hash")
}

# Função para obter a branch onde o commit foi feito
get_branch() {
  local merge_hash=$1
  git name-rev --name-only "$merge_hash" 2>/dev/null | sed -e 's/origin\///' -e 's/remotes\///'
}

# Função para obter o autor do merge
get_author() {
  local merge_hash=$1
  git show -s --format='%an' "$merge_hash"
}

# Função principal
main() {
  local -a merge_hashes=("$@")
  declare -A unique_files=()

  if [ ${#merge_hashes[@]} -eq 0 ]; then
    echo "Uso: $0 <MERGE_HASH> [<MERGE_HASH> ...]"
    exit 1
  fi

  for merge_hash in "${merge_hashes[@]}"; do
    local files
    files=$(get_changed_files "$merge_hash")

    if [ -z "$files" ]; then
      echo "Nenhum arquivo encontrado para o hash $merge_hash"
      continue
    fi

    local branch
    branch=$(get_branch "$merge_hash")
    local author
    author=$(get_author "$merge_hash")

    echo -e "\033[1m$branch\033[0m (\033[1m$author\033[0m)"
    while IFS= read -r file; do
      if [ -n "$file" ]; then
        if [[ -z "${unique_files["$file"]}" ]]; then
          unique_files["$file"]=1
          file_parts=(${file//\// })
          filename=${file_parts[-1]}
          file_path=${file%/*}

          if [ "$file" == "$filename" ]; then
            file_path=""
          fi

          echo -e "$file_path/\033[1m$filename\033[0m"
        fi
      fi
    done <<< "$files"
  done
}

main "$@"
