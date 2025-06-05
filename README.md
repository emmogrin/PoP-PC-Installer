PoP Node Installer for PC (Docker-based)

This setup script installs and runs the PoP Node using Docker on any Ubuntu-based PC.

■■Due to frequent updates (this removes the previous version)
■■if this is your first time, skip to quick start.
```
rm -rf install_pop_pc.sh
```

Quick Start
```
curl -O https://raw.githubusercontent.com/emmogrin/PoP-PC-Installer/main/install_pop_pc.sh
chmod +x install_pop_pc.sh
./install_pop_pc.sh
```
What It Does

Installs required packages (Docker, libssl-dev, etc.)

Sets system optimizations

Downloads and extracts PoP binary

Prompts user to input configuration

Builds and runs Docker container for PoP node

Displays real-time logs on completion


Auto-Start on Reboot

The Docker container is configured with:

--restart unless-stopped

This ensures the PoP node automatically restarts after a reboot if Docker is running.

Manual Commands

If needed, you can manually control the PoP node with:

# Start the PoP node container manually after reboot
```
sudo docker start popnode
```
# View logs
```
sudo docker logs -f popnode
```
# Check if Docker is running
```
systemctl status docker
```
# If Docker is not active:
```
sudo systemctl start docker
```
Health Checks

To confirm your node is running properly:
```
curl http://<your-vps-ip>/health
curl -k https://<your-vps-ip>/health | jq
```
# Node state:
```
curl -k https://<your-vps-ip>/state | jq
```
# Node metrics:
```
curl -k https://<your-vps-ip>/metrics | jq
```
Branding

Brought to you by:

SAINT KHEN
Twitter: @admirkhen


---

Need help? DM me on Twitter! @admirkhen 

