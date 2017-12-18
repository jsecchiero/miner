# miner

Out-of-box toolkit for miners

## requirements

- cpu feature _VT-d_
- kernel paramenter _modprobe.blacklist=your gpu driver_
- docker
- check apparmor/selinux

## usage

Use the SCRIPT env variable for choose the desired tool or install one yourself

## example

```
docker run --name miner --privileged -d -v /sys/fs/cgroup:/sys/fs/cgroup:rw -e SCRIPT="ethminer -M 1 -G -F http://eth-eu.dwarfpool.com/0xe6bc9af3c835e001d74aba0cb16619dbde8f29f0" jsecchiero/miner
```

monitor the running job with

```
docker exec -it miner journalctl -u vagrant -f
```

## note

This project is still in development, more documentation will be added in the future. Stay tuned!  
Actually the hardware support is limited to AMD because i don't have nvidia cards  
Actually only ethminer tool is available  
