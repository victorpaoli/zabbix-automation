#!/bin/bash

# Atualizar o sistema e instalar dependências básicas
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl

# Verificar e instalar o Docker
if ! command -v docker &>/dev/null; then
  echo "Docker não encontrado. Instalando..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
else
  echo "Docker já está instalado."
fi

# Verificar e instalar o Docker Compose (plugin nativo)
if ! command -v docker compose &>/dev/null; then
  echo "Instalando o Docker Compose..."
  sudo apt install -y docker-compose-plugin
else
  echo "Docker Compose já está instalado."
fi

# Remover containers antigos para evitar conflitos
echo "Removendo containers antigos, se existirem..."
sudo docker compose down --remove-orphans || true
sudo docker rm -f zabbix-server zabbix-web zabbix-agent2 zabbix-db || true
sudo docker volume rm zbx_db || true

# Criar o diretório do docker-compose.yaml
sudo mkdir -p /home/zabbix/
cd /home/zabbix/

# Criar o arquivo docker-compose.yaml
cat <<EOF > /home/zabbix/docker-compose.yaml
version: '3.8'
services:
  zabbix-server:
    container_name: "zabbix-server"
    image: zabbix/zabbix-server-pgsql:ubuntu-7.2-latest
    restart: always
    ports:
      - 10051:10051
    networks:
      - zabbix-net
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
    environment:
      DB_SERVER_HOST: "db"
      POSTGRES_USER: "zabbix"
      POSTGRES_PASSWORD: "zabbix123"
      POSTGRES_DB: "zabbix_db"
      ZBX_CACHESIZE: 2048M
      ZBX_HISTORYCACHESIZE: 512M
      ZBX_TRENDCACHESIZE: 512M

  zabbix-web-nginx-pgsql:
    container_name: "zabbix-web"
    image: zabbix/zabbix-web-nginx-pgsql:ubuntu-7.2-latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    networks:
      - zabbix-net
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
    environment:
      DB_SERVER_HOST: "db"
      POSTGRES_USER: "zabbix"
      POSTGRES_PASSWORD: "zabbix123"
      POSTGRES_DB: "zabbix_db"
      ZBX_MEMORYLIMIT: "1024M"

  zabbix-agent2:
    container_name: "zabbix-agent2"
    image: zabbix/zabbix-agent2:ubuntu-7.2-latest
    restart: always
    ports:
      - 10050:10050
    networks:
      - zabbix-net
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
    environment:
      ZBX_HOSTNAME: "zabbix-agent2"
      ZBX_SERVER_HOST: "zabbix-server"

  db:
    container_name: "zabbix-db"
    image: postgres:15.6
    restart: always
    volumes:
      - zbx_db:/var/lib/postgresql/data
    ports:
      - 5432:5432
    networks:
      - zabbix-net
    environment:
      POSTGRES_USER: "zabbix"
      POSTGRES_PASSWORD: "zabbix123"
      POSTGRES_DB: "zabbix_db"

networks:
  zabbix-net:
    driver: bridge

volumes:
  zbx_db:
EOF

# Subir os containers com Docker Compose
echo "Iniciando os containers..."
sudo docker compose up -d

# Mostrar o estado dos containers
echo "Containers em execução:"
sudo docker ps

# Instrução para logs
echo "Para ver os logs de um container, use: sudo docker logs <nome_do_container>"
