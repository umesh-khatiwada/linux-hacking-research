#!/bin/bash

# setup-ssh-mfa.sh
# Automates the setup of Google Authenticator MFA for SSH on Debian-based systems.

set -e

# Check for root/sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo."
   exit 1
fi

echo "Updating package list and installing libpam-google-authenticator..."
apt update
apt install -y libpam-google-authenticator

# Configure PAM for SSH
PAM_SSHD="/etc/pam.d/sshd"
MFA_LINE="auth required pam_google_authenticator.so nullok"

if ! grep -q "pam_google_authenticator.so" "$PAM_SSHD"; then
    echo "Adding MFA configuration to $PAM_SSHD (after password)..."
    # Add it AFTER @include common-auth so password is asked first
    sed -i "/@include common-auth/a $MFA_LINE" "$PAM_SSHD"
else
    echo "MFA configuration already exists in $PAM_SSHD."
fi

echo "--- PUBKEY OPTIMIZATION ---"
echo "If you want to use Public Key + MFA WITHOUT being asked for a password,"
echo "you must comment out '@include common-auth' in $PAM_SSHD."
echo "Use with caution: this disables password login entirely for SSH!"
echo "---------------------------"

# Configure SSH daemon
SSHD_CONFIG="/etc/ssh/sshd_config"

echo "Updating $SSHD_CONFIG..."
sed -i 's/^#\(KbdInteractiveAuthentication\) .*/\1 yes/' "$SSHD_CONFIG"
sed -i 's/^\(KbdInteractiveAuthentication\) .*/\1 yes/' "$SSHD_CONFIG"

# Note: AuthenticationMethods might not exist, so we append if not found
if ! grep -q "AuthenticationMethods" "$SSHD_CONFIG"; then
    echo "AuthenticationMethods publickey,keyboard-interactive" >> "$SSHD_CONFIG"
else
    sed -i 's/^#\(AuthenticationMethods\) .*/\1 publickey,keyboard-interactive/' "$SSHD_CONFIG"
    sed -i 's/^\(AuthenticationMethods\) .*/\1 publickey,keyboard-interactive/' "$SSHD_CONFIG"
fi

echo "Restarting SSH service..."
systemctl restart ssh

echo "---------------------------------------------------------"
echo "Setup complete! Now, EACH USER must run 'google-authenticator' to set up their individual MFA tokens."
echo "Keep your recovery codes in a safe place."
echo "---------------------------------------------------------"
