# -*- mode: ruby -*-
# vi: set ft=ruby :

load 'pci_devices.rb'

amd_gpu = get_pci_id('Device','Radeon')
nvidia_gpu = get_pci_id('Vendor','Nvidia').keep_if { |k, v| get_pci_id('Class','VGA').key? k }

Vagrant.configure("2") do |config|

  count  = 0
  amd_gpu.each_key do |pci_id|

    miner_hostname = "miner-amd-" + count.to_s
    config.vm.define miner_hostname do |node|

      node.vm.provision "shell" do |s|
        s.path = "provision.sh"
        s.args = "'" + ENV["SCRIPT"] + "'"
      end

      node.vm.synced_folder ".", "/home/vagrant/sync", disabled: true
      node.vm.box = "jsecchiero/miner-amd"

      node.vm.provider :libvirt do |domain|
        domain.memory = 1024
        domain.cpus = 1
        domain.kvm_hidden = true
        domain.graphics_ip = 'localhost'
        domain.video_type = 'qxl'
        bus = pci_id.split(':')[0]
        slot = pci_id.split(':')[1]
        amd_gpu[pci_id].each do |function|
          domain.pci :bus => bus, :slot => slot, :function => function
        end
      end
    end
    count += 1
  end

  count  = 0
  nvidia_gpu.each_key do |pci_id|

    miner_hostname = "miner-nvidia-" + count.to_s
    config.vm.define miner_hostname do |node|

      node.vm.provision "shell" do |s|
        s.path = "provision.sh"
        s.args = "'" + ENV["SCRIPT"] + "'"
      end

      node.vm.synced_folder ".", "/home/vagrant/sync", disabled: true
      node.vm.box = "jsecchiero/miner-nvidia" # TODO

      node.vm.provider :libvirt do |domain|
        domain.memory = 1024
        domain.cpus = 1
        domain.kvm_hidden = true
        domain.graphics_ip = 'localhost'
        domain.video_type = 'qxl'
        bus = pci_id.split(':')[0]
        slot = pci_id.split(':')[1]
        nvidia_gpu[pci_id].each do |function|
          domain.pci :bus => bus, :slot => slot, :function => function
        end
      end
    end
    count += 1
  end
end
