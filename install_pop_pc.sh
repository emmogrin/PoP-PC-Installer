#!/bin/bash

echo "████████████████████████████████████████████████████████████████"
echo "██           SAINT KHEN| X:@admirkhen | PipeNode PC/VPS INSTALLER (LINUX)             ██"
echo "████████████████████████████████████████████████████████████████"
sleep 1

# Ask user for setup info
read -p "Enter PoP Name (e.g. khen1): " POP_NAME
read -p "Enter Location (e.g. china): " POP_LOCATION
read -p "Enter Invite Code: " INVITE_CODE
read -p "Enter Email: " EMAIL
read -p "Enter Discord Username (e.g. jijinwang): " DISCORD
read -p "Enter Telegram Username (with @): " TELEGRAM
read -p "Enter Solana Wallet Address (for rewards): " SOLANA_PUBKEY

# Create working directory
mkdir -p ~/popcache
cd ~/popcache || exit 1

# Download and extract PoP binary
wget -O pop-x86_64.tar.gz https://download.pipe.network/static/pop-v0.3.0-linux-x64.tar.gz
tar -xzf pop-x86_64.tar.gz
chmod +x ./pop

# Create full config.json
cat > config.json <<EOF
{
  "pop_name": "$POP_NAME",
  "pop_location": "$POP_LOCATION",
  "invite_code": "$INVITE_CODE",
  "server": {
    "host": "0.0.0.0",
    "port": 8443,
    "http_port": 8080,
    "workers": 20
  },
  "cache_config": {
    "memory_cache_size_mb": 2048,
    "disk_cache_path": "./cache",
    "disk_cache_size_gb": 50,
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

# Create systemd service
SERVICE_FILE="/etc/systemd/system/popnode.service"
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Pipe Network PoP Node
After=network.target

[Service]
ExecStart=/home/$USER/popcache/pop --config /home/$USER/popcache/config.json
WorkingDirectory=/home/$USER/popcache
Restart=always
StandardOutput=append:/home/$USER/popcache/pop.log
StandardError=append:/home/$USER/popcache/pop.log

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable popnode
sudo systemctl start popnode

echo ""
echo "✅ PoP Node setup complete. Logs below:"
echo ""
tail -f ~/popcache/pop.log
