# Nmap Scripting Engine (NSE)

NSE is one of Nmap's most powerful features, allowing users to write and share simple scripts to automate a wide variety of networking tasks.

## Categories

- `auth`: Handle authentication on the target system.
- `broadcast`: Discovery by broadcasting on the local network.
- `brute`: Brute-force credentials.
- `default`: The default set of scripts (run with `-sC`).
- `discovery`: Discover more about the network (e.g., AD, SMB shares).
- `dos`: Check for Denial of Service vulnerabilities.
- `exploit`: Attempt to exploit a vulnerability.
- `fuzzer`: Send random data to find bugs.
- `intrusive`: Scripts that might crash something or be noisy.
- `malware`: Check for backdoors or infection.
- `safe`: Scripts unlikely to crash or hurt the target.
- `vuln`: Check for specific known vulnerabilities.

## Usage

### 1. Run Default Scripts
```bash
nmap -sC <target>
```

### 2. Specific Script by Name
```bash
nmap --script smb-os-discovery <target>
```

### 3. Multiple Scripts or Categories
```bash
nmap --script "http-* and not http-brute" <target>
```

### 4. Vulnerability Scanning
```bash
nmap --script vuln <target>
```

### 5. Script Arguments
```bash
nmap --script http-title --script-args http-title.url=/ <target>
```
