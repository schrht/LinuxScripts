#!/bin/bash

# Owner: schrht@gmail.com
# Description: Mount NAS storage through WebDAV.

WEBDAVURI=https://id.synology.me:5006
MOUNTPOINT=/mnt/dav
USER=$(id -un)
GROUP=$(id -gn)

if [ "$(whoami)" != "root" ]; then
	echo -e "\nBecoming root..."
	sudo echo
fi

if (! rpm -q davfs2); then
	echo -e "\nInstalling davfs2..."
	sudo dnf install -y davfs2 || exit 1
fi

if (mount | grep -q "$MOUNTPOINT"); then
	echo -e "\nUmounting $MOUNTPOINT..."
	sudo umount $MOUNTPOINT || exit 1
fi

echo -e "\nMounting $MOUNTPOINT..."
sudo mkdir -p $MOUNTPOINT
echo -e "\nEXECUTE: sudo mount -t davfs -o noexec,uid=$USER,gid=$GROUP $WEBDAVURI $MOUNTPOINT"
sudo mount -t davfs -o noexec,uid=$USER,gid=$GROUP $WEBDAVURI $MOUNTPOINT

echo -e "\nEXECUTE: ls $MOUNTPOINT"
ls $MOUNTPOINT && echo -e "\nCompleted." || echo -e "\nFailed."

