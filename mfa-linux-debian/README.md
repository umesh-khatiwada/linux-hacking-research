

# MFA Linux Debian

Multi-Factor Authentication (MFA) implementation and security research for Debian-based Linux systems.

## Overview

This directory contains research, documentation, and tools for implementing and testing multi-factor authentication mechanisms on Debian Linux systems. It covers various MFA methods, authentication protocols, and security hardening techniques.

## Contents

- **Documentation** - MFA concepts and implementation guides
- **Scripts** - Automation scripts for MFA setup and testing
- **Configurations** - Example configuration files for various MFA solutions

## Key Topics

### MFA Methods
- **TOTP** (Time-based One-Time Password)
- **HOTP** (HMAC-based One-Time Password)
- **U2F** (Universal 2nd Factor) / FIDO2
- **WebAuthn**
- **SMS/Email Verification**
- **Hardware Security Keys**

### Authentication Mechanisms
- PAM (Pluggable Authentication Modules)
- SSH Key-based Authentication
- System Login Hardening
- Application-level MFA

## Prerequisites

- Debian-based Linux distribution (Debian, Ubuntu, Mint, etc.)
- Root or sudo access for system-level modifications
- Basic understanding of Linux authentication systems

## Quick Start

1. Review the documentation files for your use case
2. Execute relevant setup scripts with appropriate permissions
3. Test MFA functionality before deploying to production
4. Follow security best practices outlined in the guides

## Google Authenticator PAM Implementation

You can implement MFA on Debian using Google's PAM library `libpam-google-authenticator`, typically for SSH and optionally for local logins.

**Source:** [GitHub - google-authenticator-libpam](https://github.com/google/google-authenticator-libpam)

### 1. Install Google Authenticator PAM module

Run as root or with sudo:

```bash
sudo apt update
sudo apt install libpam-google-authenticator
```

This installs the PAM module `pam_google_authenticator.so` and the `google-authenticator` CLI per user.

### 2. Initialize MFA for a user

As the target user (e.g., your own account):

```bash
google-authenticator
```

Then:

- Choose time-based tokens: answer `y` to time-based authentication.
- Scan the QR code with Google Authenticator (or any TOTP app).
- Store emergency scratch codes somewhere safe.
- Answer the subsequent hardening questions (disallow multiple uses, rate limiting, etc.) with `y` for better security.

This creates `~/.google_authenticator` containing the shared secret and settings.

### 3. Integrate with PAM for SSH

Edit SSH's PAM configuration:

```bash
sudo nano /etc/pam.d/sshd
```

Add near the top (or before `@include common-auth`):

```text
auth required pam_google_authenticator.so nullok
```

- Remove `nullok` if you want MFA enforced for every account (no secret file → deny).

### 4. Configure sshd to ask for OTP

Edit SSH daemon config:

```bash
sudo nano /etc/ssh/sshd_config
```

Set or adjust:

```text
# allow interactive PAM prompts
KbdInteractiveAuthentication yes
ChallengeResponseAuthentication yes

# if you want key + OTP
AuthenticationMethods publickey,keyboard-interactive

# or password + OTP (less secure than key + OTP)
# AuthenticationMethods password,keyboard-interactive
```

Then restart SSH:

```bash
sudo systemctl restart ssh
```

Now login flow will be, e.g., key auth first, then a TOTP code prompt from PAM.

### 5. (Optional) Enforce MFA for local logins

To require MFA on TTY/console logins:

```bash
sudo nano /etc/pam.d/login
```

Add:

```text
auth required pam_google_authenticator.so
```

Similarly, to integrate with general auth stack:

```bash
sudo nano /etc/pam.d/common-auth
```

Append:

```text
auth required pam_google_authenticator.so
```

**⚠️ Important:** Test on a second session before logging out of your current root/SSH session so you don't lock yourself out.

### Implementation Tip

Use `AuthenticationMethods publickey,keyboard-interactive` so that SSH keys remain the first factor and Google Authenticator TOTP is the second, which plays nicely with existing infrastructure workflows.

## Common Use Cases

- **Server Hardening** - Implementing MFA for SSH and system login
- **Application Security** - Integrating MFA with user authentication systems
- **Security Research** - Testing attack vectors and MFA weaknesses
- **Compliance** - Meeting organizational security requirements

## Security Considerations

- Always use secure channels for MFA secret distribution
- Store backup recovery codes in a secure location
- Regularly update authentication libraries and packages
- Test MFA implementation thoroughly before production use
- Keep system packages updated with security patches

## Resources

- [Linux PAM Documentation](http://www.linux-pam.org/)
- [NIST Authentication Guidelines](https://pages.nist.gov/800-63-3/)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)

## Contributing

When adding new content:
1. Document your MFA implementation thoroughly
2. Provide working examples and test cases
3. Include security considerations
4. Update this README with new topics

## Disclaimer

This research is for educational and authorized security testing purposes only. Unauthorized access to computer systems is illegal. Always obtain proper authorization before testing security measures.

## License

See LICENSE file in the parent directory for licensing information.

---

Last Updated: February 2026
