
# 🔥 One-Click Pipe Firestarter Installer (Unofficial Wrapper)

This is a helper script to set up and run the official Pipe Firestarter tool — the easiest way to test uploading and downloading files via the Pipe CLI.

> ⚠️ I did not create Pipe Firestarter.
This script simply automates the process so you can run it in one click.
Built for beginners by @admirkhen




---

✅ What This Script Does

Installs pipe-cli from source

Creates a new Pipe user (username is your choice)

Prints your Solana wallet address for faucet use

Swaps Devnet SOL for PIPE tokens

Uploads 5MB dummy files (PDF & DOC)

Downloads and verifies the uploaded files



---

## 🧰 Requirements

Linux, Mac, or WSL

Basic tools: git, cargo, dd, curl

Internet access

At least 1 SOL (Devnet) in your wallet
➤ Get SOL from the faucet



---

## ⚙️ How To Use

if you have used the repo before (git pull)
```
git stash --include-untracked
git pull
git stash pop
chmod +x pipe-firestarter.sh
./pipe-firestarter.sh
```
if you haven't ⬇️
```
git clone https://github.com/emmogrin/PoP-PC-Installer
cd PoP-PC-Installer
chmod +x pipe-firestarter.sh
./pipe-firestarter.sh
```

---

🌱 New to Pipe?

Pipe is a decentralized storage network.

You’ll get a wallet (pubKey) address during setup looks like the image below.

go the [🔗 Solana Devnet Faucet](https://faucet.solana.com) and get devnet sol before proceeding to enter password.(note that when typing password it wont show)

[![Screenshot-20250731-075007-Termux.jpg](https://i.postimg.cc/1tcbFYNn/Screenshot-20250731-075007-Termux.jpg)](https://postimg.cc/TL1kM00f)

[Post your screenshot in Discord for fire-starter role.](https://discord.com/channels/1276592413049356391/1399519012756656189) look at the example below.



---

📁 What Gets Created

pipe-dummy/myfile.pdf – 5MB random file

pipe-dummy/sensitive.doc – 5MB random file

All uploads go through the official Firestarter backend

Your credentials saved at ~/.pipe-cli.json

[![Screenshot-20250731-070906-Termius.jpg](https://i.postimg.cc/28zLnqgV/Screenshot-20250731-070906-Termius.jpg)](https://postimg.cc/Z0MqSqbS)

---

💬 Support / Questions?

DM me: @admirkhen
PRs and suggestions welcome!

