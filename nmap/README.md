# Nmap Network Scanning Module

Comprehensive research and command reference for Nmap (Network Mapper).

## Directory Structure

- [**Host Discovery**](./host-discovery/README.md) - Techniques to identify live systems.
- [**Scan Types**](./scan-types/README.md) - Different port scanning methods (SYN, Connect, UDP, etc.).
- [**NSE Scripts**](./nse-scripts/README.md) - Using the Nmap Scripting Engine.
- [**Evasion**](./evasion/README.md) - Firewall and IDS/IPS bypass techniques.

## Cheat Sheet - Most Common Commands

| Command | Description |
| :--- | :--- |
| `nmap -sn <target>` | Ping Scan - Disable port scan |
| `nmap -sS <target>` | Stealthy SYN Scan (Requires root) |
| `nmap -sT <target>` | TCP Connect Scan (Full handshake) |
| `nmap -sV <target>` | Version Detection |
| `nmap -O <target>` | OS Detection |
| `nmap -A <target>` | Aggressive Scan (OS, Version, Scripts, Traceroute) |
| `nmap -p <port> <target>` | Scan specific port |
| `nmap -p- <target>` | Scan all 65535 ports |
| `nmap -v <target>` | Verbose output |
| `nmap -oN <file> <target>` | Save output in normal format |
| `nmap -oX <file> <target>` | Save output in XML format |

## Resources
- [Official Nmap Documentation](https://nmap.org/book/man.html)
- [Nmap Scripting Engine (NSE) Reference](https://nmap.org/nsedoc/)
