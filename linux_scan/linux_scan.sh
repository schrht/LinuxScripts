#!/bin/bash

# Name: linux_scan.sh
#
# Description:
#   A Linux script that gathers system information by running various Linux commands.
#   The script requires root privileges to run some of the commands. Once the information
#   is collected, it is saved into a tarball which can be used for further analysis or troubleshooting.
#   The script is designed to provide a comprehensive overview of the system, including information
#   about the hardware, operating system, network, and installed software.
#   It is a useful tool for system administrators and users who want to understand the configuration
#   and performance of their Linux system.
#
# Usage:
#   To run the script, execute the following command:
#   ./linux_scan.sh
#   The script requires root privileges to run some of the commands, so make sure to run it as root
#   or with sudo privileges. Once the script completes, the system information will be saved into
#   a tarball which can be found in the current directory.
#
# Maintainer: Charles Shi <schrht@gmail.com>
# Version: 1.1.0
# Update Date: 2023-03-22

function run_cmd() {
	# $1: Command to be executed
	# $2: The filename where log to be saved (optional)

	# If not root, lead the command with 'sudo'
	[ $(whoami) = root ] && cmd="$1" || cmd="sudo $1"

	if [ -z "$2" ]; then
		cmdlog=$workspace/$(echo $cmd | tr -c "[:alpha:][:digit:]" "_").log
	else
		cmdlog=$workspace/$2
	fi

	echo -e "\ncmd> $cmd" >>$logfile
	echo -e "log> $cmdlog[.err]" >>$logfile
	eval $cmd >$cmdlog 2>$cmdlog.err

	rcode=$?
	if [ $rcode != 0 ]; then
		echo -e "\ncmd> $cmd"
		cat $cmdlog.err
	fi

	return $rcode
}

export PATH=$PATH:/usr/local/sbin:/usr/sbin

# Prepare environment
workspace=linux_scan_$(hostname)_$(date +%y%m%d%H%M%S)
logfile=$workspace/linux_scan.log
mkdir -p $workspace

echo -e "\n\nInstallation:\n===============\n" >>$logfile

# Install essential tools
#sudo dnf install sysstat -y &>> $logfile
#sudo dnf install redhat-lsb -y &>> $logfile

echo -e "\n\nTest Results:\n===============\n" >>$logfile

# Start taking snapshot

## virtualization
run_cmd 'virt-what'

## system
run_cmd 'cat /proc/version'
run_cmd 'uname -r'
run_cmd 'uname -a'
run_cmd 'lsb_release -a'
run_cmd 'cat /etc/redhat-release'
run_cmd 'cat /etc/issue'
run_cmd 'cat /etc/lsb-release'
run_cmd 'cat /etc/os-release'

## bios and hardware
run_cmd 'dmidecode'
run_cmd 'dmidecode -t bios'
run_cmd 'lspci'
run_cmd 'lspci -v'
run_cmd 'lspci -vv'
run_cmd 'lspci -vvv'
run_cmd 'ls -d /sys/firmware/efi'

## package
run_cmd 'rpm -qa'
run_cmd 'dnf repolist'
run_cmd 'dnf repolist all'
run_cmd 'dnf repoinfo'
run_cmd 'dnf repoinfo all'
run_cmd 'subscription-manager list --available'
run_cmd 'subscription-manager list --consumed'
run_cmd 'find /etc/yum.repos.d -type f'
for file in $(ls /etc/yum.repos.d/*); do
	run_cmd "grep ^ $file"
done

## kernel
run_cmd 'lsmod'
run_cmd 'date'
run_cmd 'cat /proc/uptime'
run_cmd 'uptime'
run_cmd 'top -b -n 1'
run_cmd 'bash -c set'
run_cmd 'env'
run_cmd 'vmstat 3 1'
run_cmd 'vmstat -m'
run_cmd 'vmstat -a'
run_cmd 'w'
run_cmd 'who'
run_cmd 'whoami'
run_cmd 'ps -A'
run_cmd 'ps -Al'
run_cmd 'ps -AlF'
run_cmd 'ps -AlFH'
run_cmd 'ps -AlLm'
run_cmd 'ps -ax'
run_cmd 'ps -axu'
run_cmd 'ps -ejH'
run_cmd 'ps -axjf'
run_cmd 'ps -eo euser,ruser,suser,fuser,f,comm,label'
run_cmd 'ps -axZ'
run_cmd 'ps -eM'
run_cmd 'ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm'
run_cmd 'ps -axo stat,euid,ruid,tty,tpgid,sess,pgrp,ppid,pid,pcpu,comm'
run_cmd 'ps -eo pid,tt,user,fname,tmout,f,wchan'
run_cmd 'free'
run_cmd 'free -k'
run_cmd 'free -m'
run_cmd 'free -g'
run_cmd 'free -h'
run_cmd 'cat /proc/meminfo'
run_cmd 'lscpu'
run_cmd 'cat /proc/cpuinfo'
run_cmd 'mpstat -P ALL'
run_cmd 'sar -n DEV'
run_cmd 'iostat'
run_cmd 'netstat -tulpn'
run_cmd 'netstat -nat'
run_cmd 'ss -t -a'
run_cmd 'ss -u -a'
run_cmd 'ss -t -a -Z'
run_cmd 'cat /proc/zoneinfo'
run_cmd 'cat /proc/mounts'
run_cmd 'cat /proc/interrupts'
run_cmd 'dmesg'
run_cmd 'dmesg -l emerg'
run_cmd 'dmesg -l alert'
run_cmd 'dmesg -l crit'
run_cmd 'dmesg -l err'
run_cmd 'dmesg -l warn'
run_cmd 'dmesg -l notice'
run_cmd 'dmesg -l info'
run_cmd 'dmesg -l debug'
run_cmd 'dmesg -f kern'
run_cmd 'dmesg -f user'
run_cmd 'dmesg -f mail'
run_cmd 'dmesg -f daemon'
run_cmd 'dmesg -f auth'
run_cmd 'dmesg -f syslog'
run_cmd 'dmesg -f lpr'
run_cmd 'dmesg -f news'
run_cmd 'sysctl -a'

## block
run_cmd 'lsblk'
run_cmd 'lsblk -p'
run_cmd 'lsblk -d'
run_cmd 'lsblk -d -p'
run_cmd 'df -k'
run_cmd 'fdisk -l'

## network
run_cmd 'ifconfig -a'
run_cmd 'ethtool eth0'
run_cmd 'ethtool -a eth0'
run_cmd 'ethtool -i eth0'
run_cmd 'ethtool -c eth0'
run_cmd 'ethtool -g eth0'
run_cmd 'ethtool -k eth0'
run_cmd 'ethtool -n eth0'
run_cmd 'ethtool -T eth0'
run_cmd 'ethtool -x eth0'
run_cmd 'ethtool -P eth0'
run_cmd 'ethtool -l eth0'
run_cmd 'ethtool -S eth0'
run_cmd 'ethtool --phy-statistics eth0'
run_cmd 'ethtool --show-priv-flags eth0'
run_cmd 'ethtool --show-eee eth0'
run_cmd 'ethtool --show-fec eth0'
run_cmd 'ip link'
run_cmd 'ip address'
run_cmd 'ip addrlabel'
run_cmd 'ip route'
run_cmd 'ip rule'
run_cmd 'ip neigh'
run_cmd 'ip ntable'
run_cmd 'ip tunnel'
run_cmd 'ip tuntap'
run_cmd 'ip maddress'
run_cmd 'ip mroute'
run_cmd 'ip mrule'
run_cmd 'ip netns'
run_cmd 'ip l2tp show tunnel'
run_cmd 'ip l2tp show session'
run_cmd 'ip macsec show'
run_cmd 'ip tcp_metrics'
run_cmd 'ip token'
run_cmd 'ip netconf'
run_cmd 'ip ila list'
run_cmd 'hostname'
run_cmd 'cat /etc/hostname'
run_cmd 'cat /etc/hosts'
run_cmd 'ping -c 1 8.8.8.8'
run_cmd 'ping6 -c 1 2001:4860:4860::8888'

## cloud-init
run_cmd 'cat /var/log/cloud-init.log'
run_cmd 'cat /var/log/cloud-init-output.log'
run_cmd 'service cloud-init-local status'
run_cmd 'service cloud-init status'
run_cmd 'service cloud-config status'
run_cmd 'service cloud-final status'
run_cmd 'systemctl status cloud-{init-local,init,config,final}'
run_cmd 'cloud-init status'
run_cmd 'cloud-init analyze show'
run_cmd 'cloud-init analyze blame'
run_cmd 'cloud-init analyze dump'
run_cmd 'cat /var/run/cloud-init/status.json'
run_cmd 'cat /var/run/cloud-init/instance-data.json'
run_cmd 'cat /var/run/cloud-init/ds-identify.log'
run_cmd 'cat /etc/cloud/cloud.cfg'
run_cmd 'cat /run/cloud-init/cloud-init-generator.log'
run_cmd 'cat /run/cloud-init/ds-identify.log'
run_cmd 'cloud-id'

## selinux
run_cmd 'getenforce'
run_cmd 'sestatus'

## others
run_cmd 'cat /proc/buddyinfo'
run_cmd 'cat /proc/cgroups'
run_cmd 'cat /proc/cmdline'
run_cmd 'cat /proc/consoles'
run_cmd 'cat /proc/crypto'
run_cmd 'cat /proc/devices'
run_cmd 'cat /proc/diskstats'
run_cmd 'cat /proc/dma'
run_cmd 'cat /proc/execdomains'
run_cmd 'cat /proc/fb'
run_cmd 'cat /proc/filesystems'
run_cmd 'cat /proc/iomem'
run_cmd 'cat /proc/ioports'
run_cmd 'cat /proc/keys'
run_cmd 'cat /proc/key-users'
run_cmd 'cat /proc/loadavg'
run_cmd 'cat /proc/locks'
run_cmd 'cat /proc/mdstat'
run_cmd 'cat /proc/misc'
run_cmd 'cat /proc/modules'
run_cmd 'cat /proc/mtrr'
run_cmd 'cat /proc/pagetypeinfo'
run_cmd 'cat /proc/partitions'
run_cmd 'cat /proc/sched_debug'
run_cmd 'cat /proc/schedstat'
run_cmd 'cat /proc/slabinfo'
run_cmd 'cat /proc/softirqs'
run_cmd 'cat /proc/stat'
run_cmd 'cat /proc/swaps'
run_cmd 'cat /proc/sysrq-trigger'
run_cmd 'cat /proc/timer_list'
run_cmd 'cat /proc/timer_stats'
run_cmd 'cat /proc/vmallocinfo'
run_cmd 'cat /proc/vmstat'

## ostree
run_cmd 'stat /run/ostree-booted'
run_cmd 'ostree admin status'
run_cmd 'ostree admin status --verbose'
run_cmd 'rpm-ostree status'

## Vulnerablilities files check
run_cmd 'ls /sys/devices/system/cpu/vulnerabilities/'
for file in $(ls /sys/devices/system/cpu/vulnerabilities/*); do
	run_cmd "grep ^ $file"
done

## Tuned
run_cmd 'tuned-adm list'
run_cmd 'tuned-adm active'
run_cmd 'tuned-adm --verbose active'
run_cmd 'tuned-adm recommend'

## boot
## Waiting for Bootup finished
while [[ "$(sudo systemd-analyze time 2>&1)" =~ "Bootup is not yet finished" ]]; do
	echo "[$(date)] Bootup is not yet finished." >>$logfile
	sleep 2s
done
run_cmd 'systemd-analyze time'
run_cmd 'systemd-analyze blame'
run_cmd 'systemd-analyze critical-chain'
run_cmd 'systemd-analyze dot'
run_cmd 'systemctl'
run_cmd 'systemctl status'
run_cmd 'cat /var/log/messages'
run_cmd 'journalctl'

# Wrap up
echo
cp $0 $workspace/
tar -zcvf $workspace.tar.gz $workspace
echo
echo "Log files have been generated in '$workspace' and more details can be found in '$logfile'."

exit 0
