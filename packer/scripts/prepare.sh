#!/bin/bash

set -e
set -x

# Set up OS
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get clean

# Install amdgpupro
cd /tmp
wget -q --referer=http://support.amd.com https://www2.ati.com/drivers/linux/beta/ubuntu/amdgpu-pro-17.40-483984.tar.xz
tar xvf amdgpu-pro-17.40-483984.tar.xz
cd amdgpu-pro-17.40-483984
sudo ./amdgpu-pro-install -y
sudo apt-get clean
sudo sed -i "s;GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash net.ifnames=0\";GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash net.ifnames=0 amdgpu.vm_fragment_size=9\";" /etc/default/grub
sudo update-grub

# Install ethmining
wget -q -O - https://github.com/ethereum-mining/ethminer/releases/download/v0.12.0/ethminer-0.12.0-Linux.tar.gz | sudo tar xvz -C /usr/local/
sudo chmod +x /usr/local/bin/ethminer

# Install nsgminer
wget -q -O - https://www.dropbox.com/s/v3zdlbdnsjq4tz5/nsgminer-linux64-0.9.3.tar.gz?dl=0 | sudo tar xvz -C /usr/local/bin/
sudo chmod +x /usr/local/bin/nsgminer
