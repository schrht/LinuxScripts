#!/bin/bash

# Note: If the same key appears multiple times in /etc/ssh/sshd_config, sshd will take the value when it first appears.

set -e

# Disable root login via SSH
if (grep -q "^PermitRootLogin " /etc/ssh/sshd_config); then
  sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
else
  echo "PermitRootLogin no" >>/etc/ssh/sshd_config
fi

# Enable password authentication via SSH
if (grep -q "^PasswordAuthentication " /etc/ssh/sshd_config); then
  sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
else
  echo "PasswordAuthentication yes" >>/etc/ssh/sshd_config
fi

# Restart SSH daemon
systemctl restart sshd
