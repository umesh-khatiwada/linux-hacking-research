# Firewall and IDS/IPS Evasion

Methods to bypass security monitoring and access restricted services.

## Techniques

### 1. Packet Fragmentation
Splitting the headers into several packets to make it harder for packet filters.
```bash
nmap -f <target>
```

### 2. Decoys
Hiding your scan among other "decoy" IP addresses.
```bash
nmap -D RND:10 <target>
# Use specific decoys
nmap -D decoy1,decoy2,ME <target>
```

### 3. Source Port Spoofing
Making the scan appear as if it's coming from a common port (e.g., DNS port 53).
```bash
nmap --source-port 53 <target>
```

### 4. Custom Data Length
Appending random data to packets to change their fingerprint.
```bash
nmap --data-length 25 <target>
```

### 5. MAC Address Spoofing
```bash
nmap --spoof-mac Apple <target>
```

### 6. Bad Checksums
Many systems will drop packets with bad checksums, but some misconfigured firewalls might let them pass.
```bash
nmap --badsum <target>
```
