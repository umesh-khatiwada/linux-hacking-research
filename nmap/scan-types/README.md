# Port Scan Types

This section documents different port scanning techniques and their characteristics.

## Techniques

### 1. TCP SYN Scan (Stealth)
The default and most popular scan. It never completes the TCP handshake.
```bash
sudo nmap -sS <target>
```

### 2. TCP Connect Scan
Complete the three-way handshake. Used when the user doesn't have raw packet privileges.
```bash
nmap -sT <target>
```

### 3. UDP Scan
Scans for open UDP ports (e.g., DNS, DHCP, SNMP).
```bash
sudo nmap -sU <target>
```

### 4. TCP Null, FIN, and Xmas Scans
Crafty scans that use invalid flag combinations to elicit responses from certain systems.
```bash
# Null Scan
sudo nmap -sN <target>

# FIN Scan
sudo nmap -sF <target>

# Xmas Scan (PSH, URG, FIN)
sudo nmap -sX <target>
```

### 5. Idle Scan (Blind)
Uses a "zombie" host to bounce the scan off, hiding the scanning IP.
```bash
sudo nmap -sI <zombie_host> <target>
```
