# miner

Out-of-box toolkit for miners  

The main goal is:
- automatically associate each gpu with the correct VM with the latest driver installed*
- provide as much possible mining tool**

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
- docker
- check apparmor/selinux

## prepare

_These commands are thested on Fedora27_

modify this line in /etc/default/grub
```
GRUB_CMDLINE_LINUX="rd.lvm.lv=fedora/root rd.lvm.lv=fedora/swap rhgb quiet modprobe.blacklist=radeon,amdgpu intel_iommu=on video=efifb:off"
```

update grub config
```
grub2-mkconfig -o /etc/grub2-efi.cfg
```

create the file /etc/modules-load.d/vfio.conf and put those lines
```
vfio-pci
vfio
vfio_iommu_type1
```

disable selinux editing this line in /etc/selinux/config
```
SELINUX=disabled
```

install docker
```
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl enable docker
systemctl start docker
```

reboot to make those changes effective
```
reboot
```

## usage

Use the SCRIPT env variable for choose the desired tool or install one yourself

## example

```
docker run --name miner --restart=always --privileged -d -v /sys/fs/cgroup:/sys/fs/cgroup:rw -v /dev:/dev -e SCRIPT="ethminer -M 1 -G -F http://eth-eu.dwarfpool.com/0xe6bc9af3c835e001d74aba0cb16619dbde8f29f0" jsecchiero/miner
```

monitor the running job with

```
docker exec -it miner journalctl -u vagrant -f
```

## note

This project is still in development, more documentation will be added in the future. Stay tuned!  


*_The hardware support is limited to AMD because i don't have any nvidia cards_  
**_Actually only ethminer tool is available_
