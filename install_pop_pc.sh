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

# === Input Prompts ===
read -rp "Enter PoP Name (e.g. khen1): " POP_NAME
read -rp "Enter Location (e.g. china): " POP_LOCATION
read -rp "Enter Invite Code: " INVITE_CODE
read -rp "Enter Email: " EMAIL
read -rp "Enter Discord Username (e.g. jijinwang): " DISCORD
read -rp "Enter Telegram Username (with @): " TELEGRAM
read -rp "Enter Solana Wallet Address: " SOLANA_PUBKEY

# === Install Dependencies ===
apt update && apt install -y libssl-dev ca-certificates docker.io jq

# === Optimize System Settings ===
cat > /etc/sysctl.d/99-popcache.conf << EOL
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
EOL

sysctl -p /etc/sysctl.d/99-popcache.conf

cat > /etc/security/limits.d/popcache.conf << EOL
*    hard nofile 65535
*    soft nofile 65535
EOL

# === Download PoP Binary ===
mkdir -p /opt/popcache && cd /opt/popcache
wget https://download.pipe.network/static/pop-v0.3.1-linux-x64.tar.gz
tar -xzf pop-v0.3.1-linux-x64.tar.gz
chmod +x ./pop

# === Create config.json ===
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

# === Create Dockerfile ===
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

CMD ["./pop"]
EOL

# === Build and Run Docker Container ===
docker build -t popnode .
docker rm -f popnode 2>/dev/null || true

docker run -d \
  --name popnode \
  -p 80:80 \
  -p 443:443 \
  --restart unless-stopped \
  -e POP_INVITE_CODE="$INVITE_CODE" \
  popnode

echo ""
echo -e "${BOLD}${CYAN}✅ PoP Node successfully installed and started.${RESET}"
echo "📦 Container Name: popnode"
echo "📜 View logs: ${BOLD}docker logs -f popnode${RESET}"
echo ""
