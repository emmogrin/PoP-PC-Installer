#!/bin/bash

echo "==============================="
echo "🚀 Welcome to Pipe Firestarter"
echo "🔗 Powered by @admirkhen"
echo "==============================="

# STEP 1: Clone and build pipe-cli
echo "[1/4] Cloning and installing pipe-cli..."
git clone https://github.com/PipeNetwork/pipe.git
cd pipe/pipe-cli || exit
cargo install --path . || { echo "❌ Failed to install pipe-cli"; exit 1; }
cd ../.. || exit

# STEP 2: Create new user
echo ""
echo "[2/4] Creating new Pipe user..."
read -rp "👉 Enter a username for Pipe: " USERNAME
pipe new-user "$USERNAME" || { echo "❌ Failed to create user"; exit 1; }

# Extract Solana pubkey from config
SOL_PUBKEY=$(grep -o '"solana_pubkey": *"[^"]*' ~/.pipe-cli.json | awk -F'"' '{print $4}')
echo ""
echo "🪪 Your Pipe Solana wallet address is:"
echo "   $SOL_PUBKEY"
echo "💸 Visit https://faucet.solana.com/"
echo "📥 Paste your address there to receive Devnet SOL"
echo ""
read -n 1 -s -r -p "⏳ Press any key after funding your wallet..."

# STEP 3: Swap SOL for PIPE
echo ""
read -rp "🔁 Enter how much Devnet SOL to swap for PIPE [default = 1]: " AMOUNT
AMOUNT=${AMOUNT:-1}
pipe swap-sol-for-pipe "$AMOUNT" || { echo "❌ Failed to swap SOL"; exit 1; }

# STEP 4: Create 5MB dummy files
echo ""
echo "[3/4] Creating 5MB dummy files..."
mkdir -p pipe-dummy
dd if=/dev/urandom of=pipe-dummy/myfile.pdf bs=1M count=5 status=none
dd if=/dev/urandom of=pipe-dummy/sensitive.doc bs=1M count=5 status=none

# STEP 5: Upload and download test
echo "[4/4] Running upload and download test..."

pipe upload-file pipe-dummy/myfile.pdf stored-name
pipe download-file stored-name downloaded.pdf

pipe upload-file pipe-dummy/sensitive.doc secure
pipe download-file secure decrypted.doc

echo ""
echo "✅ Done! Your Pipe CLI is working. Test files uploaded & downloaded."
