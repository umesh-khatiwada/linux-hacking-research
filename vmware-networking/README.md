# VMware Networking Comprehensive Report

## 1. Introduction
VMware networking allows virtual machines (VMs) to communicate with each other, the host system, and external networks. Understanding the different networking modes is crucial for building secure and functional lab environments.

## 2. Installation & Kernel Module Setup
Before configuring networking, ensure that the necessary kernel modules are built and installed. This is often required after a kernel update.

### Install Dependencies
```bash
sudo apt update
sudo apt install build-essential linux-headers-$(uname -r)
```

### Build & Install VMware Modules
```bash
sudo vmware-modconfig --console --install-all
```

## 3. Core Networking Modes

### Bridged Networking
- **Description**: The VM appears as a unique device on the same physical network as the host.
- **IP Address**: Obtained from the same DHCP server as the host.
- **Use Case**: Best for VMs that need to be fully accessible from the local network (e.g., servers).

### NAT (Network Address Translation)
- **Description**: The VM shares the host's IP address but has its own internal IP range. The host acts as a router.
- **IP Address**: Assigned by VMware's internal DHCP server.
- **Use Case**: Default mode for most VMs. Provides internet access while hiding the VM from the external network.

### Host-Only Networking
- **Description**: The VM can communicate only with the host and other VMs on the same host-only network.
- **IP Address**: Assigned by VMware's internal DHCP server on a private subnet.
- **Use Case**: Ideal for isolated labs, malware analysis, or sensitive services that should not have internet access.

### Custom Networking (LAN Segments)
- **Description**: Allows creating private virtual networks (LAN segments) that are completely isolated from the host and external networks.
- **Use Case**: Advanced multi-tier architecture labs (e.g., a firewall VM connecting two different LAN segments).

## 4. Virtual Network Editor
The **Virtual Network Editor** (available on Windows/Linux) allows you to:
- Modify subnet ranges for NAT and Host-Only networks.
- Configure port forwarding for NAT.
- Bind specific physical adapters to bridged networks.
- Add or remove virtual networks (VMnet0, VMnet1, VMnet8, etc.).

## 5. Pentesting & Lab Considerations
- **Isolation**: Use Host-Only or LAN Segments to prevent tools (like Nmap or exploits) from accidentally touching your production network.
- **Promiscuous Mode**: Ensure the virtual switch allows promiscuous mode if you are using packet sniffers like Wireshark inside a VM.
- **Static IPs**: For servers (Domain Controllers, Web Servers), configure static IPs within the VMware DHCP range or outside it but within the same subnet.

## 6. Troubleshooting
- **No IP Address**: Restart VMware DHCP services on the host.
- **No Internet in NAT**: Check if the "VMware NAT Service" is running on the host.
- **Cannot Ping Host**: Check host firewall settings; by default, Windows Firewall may block ICMP requests from different subnets.

---

## 7. Creating an Isolated Network (Bridge)

For lab environments, you often need an isolated network that acts like a private switch (bridge) between specific VMs.

### Option A: Using "LAN Segments" (Recommended for Isolation)
LAN Segments are purely internal to VMware. They do not have a DHCP server or a gateway unless you provide one via a VM.
- **Setup**: VM Settings -> Network Adapter -> LAN Segments -> Add/Select a segment.
- **Characteristics**: Extremely fast, no overhead, completely invisible to the host OS.

### Option B: Custom Host-Only (Isolated with Host Access)
If you need the host to communicate with the isolated network, use a custom VMnet (e.g., `vmnet2`).

#### CLI Commands (Linux)
To manage and status networks from the terminal:
```bash
# Check status of virtual networks
sudo vmware-networks --status

# Start/Stop all VMware networking services
sudo vmware-networks --start
sudo vmware-networks --stop
```

#### Manual Configuration (Advanced)
VMware network settings on Linux are stored in `/etc/vmware/networking`. You can manually add an isolated network by editing this file (requires `sudo`):
```text
answer VNET_2_HOSTONLY_NETMASK 255.255.255.0
answer VNET_2_HOSTONLY_SUBNET 10.10.10.0
answer VNET_2_TYPE hostonly
```
After editing, restart the services:
```bash
sudo vmware-networks --stop
sudo vmware-networks --start
```

### Option C: Bridging to a Dummy Interface
To use the "Bridged" mode while staying isolated from the physical network, bridge your VM to a Linux dummy interface.

1. **Create a dummy interface on the host**:
   ```bash
   sudo ip link add isolated-br0 type dummy
   sudo ip link set isolated-br0 up
   ```

2. **Map the dummy interface to a VMnet**:
   Open the **Virtual Network Editor** (`vmware-netcfg`) and bridge a VMnet (e.g., `vmnet2`) specifically to `isolated-br0`.

3. **Configure the VM**:
   Set the VM's Network Adapter to use the custom VMnet (e.g., `vmnet2`).

### Option D: Native Linux Bridge (System-Wide Isolation)
Instead of using VMware's internal bridging, you can create a standard Linux bridge and connect VMware to it. This allows you to easily connect other non-VMware services (like Docker or local services) to the same isolated network.

1. **Create the bridge**:
   ```bash
   sudo ip link add name vm-bridge0 type bridge
   sudo ip link set vm-bridge0 up
   ```

2. **Configure VMware**:
   - Use the Virtual Network Editor (`vmware-netcfg`) to bridge a VMnet to `vm-bridge0`.
   - Any VM on this VMnet will now be on the `vm-bridge0` broadcast domain.

### Option E: Gateway VM (Architecture-based Isolation)
This is the most "professional" way to handle lab isolation. You create a "Router VM" that has two network interfaces:
1. **WAN Interface**: Connected to VMware NAT (for internet access).
2. **LAN Interface**: Connected to a **LAN Segment** or an isolated **Host-Only** network.

**How it works**:
- All your lab VMs connect *only* to the LAN Segment.
- They use the Gateway VM's LAN IP as their default gateway.
- You can run **pfSense**, **OPNsense**, or a simple **Debian/iptables** VM as the gateway.
- This allows you to capture all traffic at the gateway, implement firewall rules, and simulate real-world networking.

---
## 8. Comparison Table

| Method | Isolation Level | Host Access | Internet Access | Setup Complexity |
| :--- | :--- | :--- | :--- | :--- |
| **LAN Segment** | High | No | No (Directly) | Easy |
| **Host-Only** | Medium | Yes | No (Directly) | Easy |
| **Dummy Bridge** | High | Yes (Dummy) | No | Medium |
| **Gateway VM** | Very High | Optional | Via Gateway | Hard |

---
*Created as part of the Linux Hacking Research project.*
