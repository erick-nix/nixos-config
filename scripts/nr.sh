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

nrupdate() {
  cd /etc/nixos || {
    echo "Error: unable to access /etc/nixos"
    return 1
  }

  echo -e "\033[36mNRUPDATE: Updating flake inputs...\033[0m"
  sudo nix flake update

  echo -e "\033[36mNRUPDATE: Testing new configuration...\033[0m"
  nh os test . -H "$(hostname)"

  echo -e "\033[33mNRUPDATE: Review the changes above\033[0m"
  echo -e "\033[33mNRUPDATE: If everything works, run 'nrall' to commit and switch\033[0m"
}

nrdeploy() {
  cd /etc/nixos || return 1

  HOST=$(hostname)

  echo -e "\033[36mNRDEPLOY: Fetching origin/main...\033[0m"
  if ! sudo git fetch origin; then
    echo -e "\033[31mNRDEPLOY: git fetch failed.\033[0m"
    return 1
  fi

  LOCAL=$(sudo git rev-parse HEAD)
  REMOTE=$(sudo git rev-parse origin/main)

  if [ "$LOCAL" != "$REMOTE" ]; then
    echo -e "\033[33mNRDEPLOY: Updating working tree to origin/main\033[0m"
    sudo git reset --hard origin/main
  else
    echo -e "\033[32mNRDEPLOY: Already up to date.\033[0m"
  fi

  echo -e "\033[36mNRDEPLOY: Running nixos-rebuild for $HOST...\033[0m"
  if ! nh os switch . -H "$HOST"; then
    echo -e "\033[31mNRDEPLOY: Build or switch failed.\033[0m"
    return 1
  fi

  echo -e "\033[32mNRDEPLOY: Deployment complete.\033[0m"
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
