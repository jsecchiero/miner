# Copyright: Pieter Lexis <pieter@kumina.nl>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# There are no dependencies needed for this script, except for lspci.
# This script is only tested on Debian (Lenny and Squeeze), if you
# have any improvements, send a pull request, ticket or email.
# The latest version of this script is available on github at
# https://github.com/kumina/fact-pci_devices

def get_pci_id(name)

  lspci = "/usr/sbin/lspci"

  # We can't do this if we don't know the location of lspci
  if !lspci.empty? and FileTest.exists?(lspci)
    # Create a hash of ALL PCI devices, the key is the PCI slot ID.
    # { SLOT_ID => { ATTRIBUTE => VALUE }, ... }
    slot=""
    # after the following loop, devices will contain ALL PCI devices and the info returned from lspci
    devices = {}
    %x{#{lspci} -v -mm -k}.each_line do |line|
      if not line =~ /^$/ # We don't need to parse empty lines
        splitted = line.split(/\t/)
        # lspci has a nice syntax:
        # ATTRIBUTE:\tVALUE
        # We use this to fill our hash
        if splitted[0] =~ /^Slot:$/
          slot=splitted[1].chomp
          devices[slot] = {}
        else
          # The chop is needed to strip the ':' from the string
          devices[slot][splitted[0].chop] = splitted[1].chomp
        end
      end
    end

    pci_filter = {}
    devices.each_key do |a|
      case devices[a].fetch("Device")
      when /#{name}/
        bus = a.split(':')[0]
        slot = a.split(':')[1].split('.')[0]
        pci_id = bus + ':' + slot
        function = a.split('.')[1]
        if !pci_filter.key?(pci_id)
          pci_filter[pci_id] = []
        end
        pci_filter[pci_id].push(function)
      end
    end

    return pci_filter
  end
end
