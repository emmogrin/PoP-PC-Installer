#!/bin/bash

# PoP Node Auto-Update Script (by @admirkhen)
# Make sure you're in /opt/popcache before running this!

echo ""
echo "🔁 Stopping current Docker container..."
docker stop popnode 2>/dev/null
docker rm popnode 2>/dev/null

echo ""
echo "⬇️ Downloading latest PoP v0.3.2..."
wget -O pop-v0.3.2.tar.gz https://download.pipe.network/static/pop-v0.3.2-linux-x64.tar.gz

echo "📦 Extracting binary..."
tar -xzf pop-v0.3.2.tar.gz
chmod +x ./pop

echo ""
echo "🐳 Rebuilding Docker image..."
docker build -t popnode .

echo ""
read -p "🎟️ Enter your Invite Code: " INVITE_CODE

echo "🚀 Restarting PoP Node container..."
docker run -d \
  --name popnode \
  -p 80:80 \
  -p 443:443 \
  --restart unless-stopped \
  -e POP_INVITE_CODE="$INVITE_CODE" \
  popnode

echo ""
echo "✅ PoP Node v0.3.2 updated & running!"
echo "📜 View logs: docker logs -f popnode"
