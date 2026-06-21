start-proxy() {
  echo -e "\033[36mSTART-PROXY: Iniciando túnel SSH com proxy SOCKS...\033[0m"
  
  if pgrep -f "ssh.*-D 1080.*ssh.erick-nix.com" > /dev/null; then
    echo -e "\033[33mSTART-PROXY: Túnel SSH já está ativo\033[0m"
  else
    ssh -p 443 -D 1080 -N -f erick-nix@ssh.erick-nix.com
    
    if [ $? -eq 0 ]; then
      echo -e "\033[32mSTART-PROXY: Túnel SSH iniciado (localhost:1080)\033[0m"
    else
      echo -e "\033[31mSTART-PROXY: Falha ao iniciar túnel SSH\033[0m"
      return 1
    fi
  fi

  echo -e "\033[36mSTART-PROXY: Configurando proxy do sistema...\033[0m"
  gsettings set org.gnome.system.proxy mode 'manual'
  gsettings set org.gnome.system.proxy.socks host 'localhost'
  gsettings set org.gnome.system.proxy.socks port 1080
  
  export http_proxy="socks5://localhost:1080"
  export https_proxy="socks5://localhost:1080"
  export ftp_proxy="socks5://localhost:1080"
  export no_proxy="localhost,127.0.0.1,::1"
  
  echo -e "\033[32mSTART-PROXY: Proxy configurado no sistema\033[0m"
  echo -e "\033[33mSTART-PROXY: Para usar em terminais novos, execute: source-proxy\033[0m"
}

stop-proxy() {
  echo -e "\033[36mSTOP-PROXY: Parando túnel SSH...\033[0m"
  
  pkill -f "ssh.*-D 1080.*ssh.erick-nix.com"
  
  if [ $? -eq 0 ]; then
    echo -e "\033[32mSTOP-PROXY: Túnel SSH encerrado\033[0m"
  else
    echo -e "\033[33mSTOP-PROXY: Nenhum túnel SSH encontrado\033[0m"
  fi

  echo -e "\033[36mSTOP-PROXY: Removendo configuração de proxy do sistema...\033[0m"
  gsettings set org.gnome.system.proxy mode 'none'
  
  unset http_proxy
  unset https_proxy
  unset ftp_proxy
  unset no_proxy
  
  echo -e "\033[32mSTOP-PROXY: Proxy removido do sistema\033[0m"
}
