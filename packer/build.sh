#!/bin/bash

export PACKER_LOG=1

# Gathering some system info
echo sudo lscpu
sudo lscpu
echo sudo cat /proc/cpuinfo
sudo cat /proc/cpuinfo
echo sudo lsmod | grep kvm
sudo lsmod | grep kvm

# Install requirements
curl -L -o packer.zip https://releases.hashicorp.com/packer/1.1.3/packer_1.1.3_linux_amd64.zip && unzip -d bin packer.zip
curl -L -o vagrant.deb https://releases.hashicorp.com/vagrant/2.0.1/vagrant_2.0.1_x86_64.deb
sudo apt-get install -f $(pwd)/vagrant.deb
sudo apt-get install -y qemu libvirt-bin ebtables dnsmasq libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev

cd $(dirname $0)
# Download base image
vagrant box add generic/ubuntu1604 --provider=libvirt --box-version=1.3.25 || true
# Start build
packer build -var "mirror=${HOME}/.vagrant.d/boxes/generic-VAGRANTSLASH-ubuntu1604/1.3.25/libvirt/box.img" -var "cloud_token=${CLOUD_TOKEN}" miner-amd.json
