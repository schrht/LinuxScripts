#!/bin/bash

set -e

NEW_USER="myuser"
NEW_USER_PASSWD="changeme"
#NEW_USER_PUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJ8Z0..."

# Add a new user
useradd -m -s /bin/bash $NEW_USER

# Set the password for the new user
if [[ ! -z $NEW_USER_PASSWD ]]; then
  echo "$NEW_USER:$(openssl passwd -6 $NEW_USER_PASSWD)" | chpasswd -e
fi

# Set up SSH key authentication for the new user
if [[ ! -z $NEW_USER_PUBKEY ]]; then
  mkdir -p /home/$NEW_USER/.ssh
  echo "$NEW_USER_PUBKEY" >>/home/$NEW_USER/.ssh/authorized_keys
  chown -R $NEW_USER: /home/$NEW_USER/.ssh
  chmod 700 /home/$NEW_USER/.ssh
  chmod 600 /home/$NEW_USER/.ssh/authorized_keys
fi

# Add user to sudoers group
echo "$NEW_USER ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/$NEW_USER
