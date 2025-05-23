#!/bin/bash

# Styled banner
BOLD='\033[1m'
CYAN='\033[96m'
RESET='\033[0m'
echo -e "\n${BOLD}${CYAN}Launching SAINT KHEN PoP Node Setup via Docker...${RESET}\n"
sleep 1

# User inputs
read -p "Enter PoP Name (e.g. khen1): " POP_NAME
read -p "Enter Location (e.g. china): " POP_LOCATION
read -p "Enter Invite Code: " INVITE_CODE
read -p "Enter Email: " EMAIL
read -p "Enter Discord Username (e.g. jijinwang): " DISCORD
read -p "Enter Telegram Username (with @): " TELEGRAM
read -p "Enter Solana Wallet Address: " SOLANA_PUBKEY

# Create project folder
mkdir -p ~/popnode-docker && cd ~/popnode-docker

# Write config.json
cat > config.json <<EOF
{
  "pop_name": "$POP_NAME",
  "pop_location": "$POP_LOCATION",
  "invite_code": "$INVITE_CODE",
  "server": {
    "host": "0.0.0.0",
    "port": 8443,
    "http_port": 8080,
    "workers": 40
  },
  "cache_config": {
    "memory_cache_size_mb": 8192,
    "disk_cache_path": "./cache",
    "disk_cache_size_gb": 80,
    "default_ttl_seconds": 86400,
    "respect_origin_headers": true,
    "max_cacheable_size_mb": 1024
  },
  "api_endpoints": {
    "base_url": "https://dataplane.pipenetwork.com"
  },
  "identity_config": {
    "node_name": "pipenode",
    "name": "$POP_NAME",
    "email": "$EMAIL",
    "website": "",
    "discord": "$DISCORD",
    "telegram": "$TELEGRAM",
    "solana_pubkey": "$SOLANA_PUBKEY"
  }
}
EOF

# Write Dockerfile
cat > Dockerfile <<EOF
FROM ubuntu:24.04
RUN apt update && apt install -y wget tar
WORKDIR /app
RUN wget -O pop-x86_64.tar.gz https://download.pipe.network/static/pop-v0.3.0-linux-x64.tar.gz \\
 && tar -xzf pop-x86_64.tar.gz \\
 && chmod +x ./pop
COPY config.json ./config.json
CMD ["./pop", "--config", "./config.json"]
EOF

# Write docker-compose.yml
cat > docker-compose.yml <<EOF
version: "3.9"
services:
  popnode:
    build: .
    container_name: popnode
    volumes:
      - ./cache:/app/cache
    ports:
      - "8080:8080"
      - "8443:8443"
    restart: unless-stopped
EOF

# Build and run the container
docker-compose up -d --build

# Show logs
echo -e "\n${BOLD}✅ PoP Node Docker container running. Logs:${RESET}\n"
docker logs -f popnode
