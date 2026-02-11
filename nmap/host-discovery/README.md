# Host Discovery

This section covers techniques for discovering live hosts on a network.

## Commands

### 1. Simple Ping Sweep
Check which IP addresses in a range are alive without scanning ports.
```bash
nmap -sn 192.168.1.0/24
```

### 2. ARP Scan
Used for discovering hosts on the local ethernet network.
```bash
nmap -PR -sn 192.168.1.0/24
```

### 3. ICMP Echo, Timestamp, and Mask Request
Different ICMP methods to bypass simple ping filters.
```bash
nmap -PE -PP -PM -sn 192.168.1.0/24
```

### 4. TCP SYN and ACK Ping
Useful for discovering hosts behind firewalls that block ICMP.
```bash
nmap -PS22,80,443 -sn 192.168.1.0/24
nmap -PA22,80,443 -sn 192.168.1.0/24
```

### 5. DNS Discovery
List targets and perform reverse DNS resolution.
```bash
nmap -sL 192.168.1.0/24
```
