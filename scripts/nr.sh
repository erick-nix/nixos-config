_nr_stage_flake_paths() {
  local -a untracked_files deleted_files
  local file

  if ! sudo -v; then
    echo -e "\033[31mNR: sudo authentication failed.\033[0m"
    return 1
  fi

  while IFS= read -r file; do
    [ -n "$file" ] && untracked_files+=("$file")
  done < <(sudo -n git ls-files --others --exclude-standard)

  while IFS= read -r file; do
    [ -n "$file" ] && deleted_files+=("$file")
  done < <(sudo -n git ls-files --deleted)

  if ((${#untracked_files[@]} > 0)); then
    echo -e "\033[36mNR: Staging untracked files for flake input...\033[0m"
    sudo -n git add -- "${untracked_files[@]}"
  fi

  if ((${#deleted_files[@]} > 0)); then
    echo -e "\033[36mNR: Staging deleted files for rename/delete consistency...\033[0m"
    sudo -n git add -- "${deleted_files[@]}"
  fi
}

nrall() {
  local mode="switch"
  case "${1:-}" in
  --boot) mode="boot" ;;
  --test) mode="test" ;;
  "") ;;
  *)
    echo "Usage: nrall [--test|--boot]"
    return 1
    ;;
  esac

  cd /etc/nixos || return 1

  _nr_stage_flake_paths || return 1

  HOST=$(hostname)
  echo -e "\033[36mNRALL: Running nh os $mode for $HOST\033[0m"
  if ! nh os "$mode" . -H "$HOST"; then
    echo -e "\033[31mNRALL: Build failed.\033[0m"
    return 1
  fi

  echo -e "\033[32mNRALL: Done.\033[0m"
}

nrremote() {
  local remote="$1"
  local mode="switch"
  local target_host="server"

  if [ -z "$remote" ]; then
    echo "Usage: nrremote user@ip [--test|--boot] [target-host]"
    return 1
  fi

  shift
  while [ $# -gt 0 ]; do
    case "$1" in
    --test) mode="test" ;;
    --boot) mode="boot" ;;
    --switch) mode="switch" ;;
    *)
      target_host="$1"
      ;;
    esac
    shift
  done

  cd /etc/nixos || return 1

  _nr_stage_flake_paths || return 1

  echo -e "\033[36mNRREMOTE: Running nh os $mode for $target_host on $remote\033[0m"
  if nh os "$mode" . -H "$target_host" --target-host "$remote"; then
    echo -e "\033[32mNRREMOTE: Remote deployment completed successfully.\033[0m"
  else
    echo -e "\033[31mNRREMOTE: Remote deployment failed.\033[0m"
    return 1
  fi
}
