# miner

Out-of-box toolkit for miners  

The main goal is:
- automatically associate each gpu with the correct VM with the latest driver installed*
- provide as much possible mining tool

## requirements

- cpu feature _VT-d_
- kernel paramenter:
  - modprobe.blacklist=your gpu driver
  - video=efifb:off
  - intel_iommu=on
- kernel module:
  - vfio
  - vfio_iommu_type1
  - vfio_pci
  - ip6_tables
- docker
- check apparmor/selinux
- ssh

## prepare

modify this line in /etc/default/grub (disable video output)  

_Fedora 27_
```
GRUB_CMDLINE_LINUX="rd.lvm.lv=fedora/root rd.lvm.lv=fedora/swap rhgb quiet modprobe.blacklist=radeon,amdgpu intel_iommu=on video=efifb:off"
```
_Ubuntu 16.04_
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash modprobe.blacklist=radeon,amdgpu intel_iommu=on video=efifb:off"
```

update grub config  

_Fedora 27_
```
grub2-mkconfig -o /etc/grub2-efi.cfg
```
_Ubuntu 16.04_
```
update-grub
```

create the file /etc/modules-load.d/vfio.conf and put those lines
```
vfio-pci
vfio
vfio_iommu_type1
ip6_tables
```

create a policy for selinux/apparmor or for test disable it  

_Fedora 27_  
editing this line /etc/selinux/config
```
SELINUX=disabled
```
_Ubuntu 16.04_
```
service apparmor stop
service apparmor teardown
update-rc.d -f apparmor remove
apt-get remove apparmor
```


install docker
```
export CHANNEL=stable
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl enable docker
systemctl start docker
```

reboot to make those changes effective
```
reboot
```

for the next connection use ssh

## usage

Use the SCRIPT env variable for choose the desired tool

## available tools  

- /usr/local/bin/ethminer
- /usr/local/bin/nsgminer

## example

```
docker run --name miner --restart=always --privileged -d -v /sys/fs/cgroup:/sys/fs/cgroup:rw -v /dev:/dev -e SCRIPT="/usr/local/bin/ethminer -M 1 -G -F http://eth-eu.dwarfpool.com/0xe6bc9af3c835e001d74aba0cb16619dbde8f29f0" jsecchiero/miner
```

list vms
```
docker exec -it miner vagrant status
```

monitor the running job with
```
docker exec -it miner vagrant ssh miner-amd-0 -c 'journalctl -u tool -f'
```

## note

This project is still in development, more documentation will be added in the future. Stay tuned!  


*_The hardware support is limited to AMD because i don't have any nvidia cards_  
