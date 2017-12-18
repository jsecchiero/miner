#!/bin/bash

export PACKER_LOG=1
vagrant box add generic/ubuntu1604 --provider=libvirt --box-version=1.3.25 || true
echo sudo lscpu
sudo lscpu
echo sudo cat /proc/cpuinfo
sudo cat /proc/cpuinfo
echo sudo lsmod | grep kvm
sudo lsmod | grep kvm
packer build -var "mirror=${HOME}/.vagrant.d/boxes/generic-VAGRANTSLASH-ubuntu1604/1.3.25/libvirt/box.img" -var "cloud_token=${CLOUD_TOKEN}" miner-amd.json
