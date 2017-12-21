# -*- mode: ruby -*-
# vi: set ft=ruby :

load 'pci_devices.rb'

pci_datas = get_pci_id('Radeon')

Vagrant.configure("2") do |config|
    
  pci_datas.each_key do |pci_id|
    config.vm.define :test_vm do |test_vm|

      test_vm.vm.provision "shell" do |s|
        s.path = "provision.sh"
        s.args = "'" + ENV["SCRIPT"] + "'"
      end

      test_vm.vm.synced_folder ".", "/home/vagrant/sync", disabled: true
      test_vm.vm.box = "jsecchiero/miner-amd"

      test_vm.vm.provider :libvirt do |domain|
        domain.memory = 2048
        domain.cpus = 1
        domain.kvm_hidden = true
        domain.graphics_ip = 'localhost'
        domain.video_type = 'qxl'
        bus = pci_id.split(':')[0]
        slot = pci_id.split(':')[1]
        pci_datas[pci_id].each do |function|
          domain.pci :bus => bus, :slot => slot, :function => function
        end
      end
    end
  end
end
