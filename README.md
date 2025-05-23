PoP PC Installer

Easy one-script installer for Pipe Network PoP Node on Linux PC (x86_64)


---

Overview

This script automates the download, configuration, and setup of the Pipe Network PoP cache node on a Linux PC. It:

Downloads the latest PoP binary (x86_64)

Creates a personalized config.json with your info

Sets up the node as a systemd service for automatic start and restart after reboot

Redirects logs to ~/popcache/pop.log

Shows live logs on first run



---

Requirements

Linux PC (x86_64 architecture)

wget, tar, systemctl, and sudo installed and configured

User must have sudo privileges



---

Usage

1. Download and run the installer script:

```
curl -O https://raw.githubusercontent.com/emmogrin/PoP-PC-Installer/main/install_pop_pc.sh
chmod +x install_pop_pc.sh
./install_pop_pc.sh
```

2. Follow the prompts (input the details its asks for in the terminal):


PoP Name

Location

Invite Code

Email

Discord username

Telegram username (with @)

Solana wallet address


3. The script will:


Download and install the PoP node

Configure it with your details

Create and enable a systemd service for automatic node startup

Start the node and show live logs



---

Managing the Node

To check logs anytime (after reboot or during use):

```
tail -f ~/popcache/pop.log
```
To manually start the node service:

```
sudo systemctl start popnode
```
To stop the node service:

```
sudo systemctl stop popnode
```
To check the service status:

```
sudo systemctl status popnode
```
To disable auto-start on boot:

```
sudo systemctl disable popnode
```

---

📝 Notes:

Make sure ports 8443 (HTTPS) and 8080 (HTTP) are free or handled properly.

If ports are busy, the node will attempt to bind alternative ports.

Logs help you troubleshoot connectivity and runtime issues.



---

Contributing

Feel free to open issues or PRs to improve the installer script or documentation.


---

License

MIT License


---

Credits

Developed by Saint Khen (GitHub: emmogrin)

Twitter: @admirkhen (known as Saint Khen on Twitter)

Inspired by Pipe Network docs and community

Thanks to Termux & Linux communities

ASCII art by Saint Khen❣️❣️❣️
