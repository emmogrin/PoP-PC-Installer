#!/bin/bash

# Bold + bright cyan color
BOLD='\033[1m'
CYAN='\033[96m'
RESET='\033[0m'

echo ""
echo -e "${BOLD}${CYAN}███████╗ █████╗ ██╗███╗   ██╗████████╗    ██╗  ██╗██╗  ██╗███████╗███╗   ██╗"
echo "██╔════╝██╔══██╗██║████╗  ██║╚══██╔══╝    ██║ ██╔╝╚██╗██╔╝██╔════╝████╗  ██║"
echo "███████╗███████║██║██╔██╗ ██║   ██║       █████╔╝  ╚███╔╝ █████╗  ██╔██╗ ██║"
echo "╚════██║██╔══██║██║██║╚██╗██║   ██║       ██╔═██╗  ██╔██╗ ██╔══╝  ██║╚██╗██║"
echo "███████║██║  ██║██║██║ ╚████║   ██║       ██║  ██╗██╔╝ ██╗███████╗██║ ╚████║"
echo "╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝       ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝"
echo -e "${BOLD}                          SAINT KHEN || @admirkhen${RESET}"
echo ""

# Prompt for config values
read -rp "Enter PoP Name (e.g. khen1): " POP_NAME
read -rp "Enter Location (e.g. china): " POP_LOCATION
read -rp "Enter Invite Code: " INVITE_CODE
read -rp "Enter Email: " EMAIL
read -rp "Enter Discord Username (e.g. jijinwang): " DISCORD
read -rp "Enter Telegram Username (with @): " TELEGRAM
read -rp "Enter Solana Wallet Address (for rewards): " SOLANA_PUBKEY

# Update and install dependencies
apt update && apt install -y libssl-dev ca-certificates docker.io jq

# Configure system limits and network settings
sudo bash -c 'cat > /etc/sysctl.d/99-popcache.conf << EOL
net.ipv4.ip_local_port_range = 1024 65535
net.core.somaxconn = 65535
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.core.wmem_max = 16777216
net.core.rmem_max = 16777216
EOL'
sudo sysctl -p /etc/sysctl.d/99-popcache.conf

sudo bash -c 'cat > /etc/security/limits.d/popcache.conf << EOL
*    hard nofile 65535
*    soft nofile 65535
EOL'

# Create working directory and download binary
sudo mkdir -p /opt/popcache
cd /opt/popcache

wget https://download.pipe.network/static/pop-v0.3.1-linux-x64.tar.gz
sudo tar -xzf pop-v0.3.1-linux-x64.tar.gz
chmod +x ./pop

# Generate config.json with your inputs
cat > config.json << EOL
{
  "pop_name": "$POP_NAME",
  "pop_location": "$POP_LOCATION",
  "invite_code": "$INVITE_CODE",
  "server": {
    "host": "0.0.0.0",
    "port": 443,
    "http_port": 80,
    "workers": 40
  },
  "cache_config": {
    "memory_cache_size_mb": 4096,
    "disk_cache_path": "./cache",
    "disk_cache_size_gb": 100,
    "default_ttl_seconds": 86400,
    "respect_origin_headers": true,
    "max_cacheable_size_mb": 1024
  },
  "api_endpoints": {
    "base_url": "https://dataplane.pipenetwork.com"
  },
  "identity_config": {
    "node_name": "$POP_NAME",
    "name": "$POP_NAME",
    "email": "$EMAIL",
    "website": "",
    "discord": "$DISCORD",
    "telegram": "$TELEGRAM",
    "solana_pubkey": "$SOLANA_PUBKEY"
  }
}
EOL

# Create Dockerfile
cat > Dockerfile << EOL
FROM ubuntu:24.04

RUN apt update && apt install -y \\
    ca-certificates \\
    curl \\
    libssl-dev \\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/popcache

COPY pop .
COPY config.json .

RUN chmod +x ./pop

CMD ["./pop", "--config", "config.json"]
EOL

# Build and run Docker container
docker build -t popnode .

docker rm -f popnode 2>/dev/null || true

docker run -d \
  --name popnode \
  -p 80:80 \
  -p 443:443 \
  --restart unless-stopped \
  popnode

echo ""
echo -e "${BOLD}${CYAN}✅ PoP Node Docker container started.${RESET}"
echo "Use: docker logs -f popnode"
echo ""
