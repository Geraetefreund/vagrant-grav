# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Config specific for grav development environment
# Version 0.1, 2025-03-16

IP_ADDRESS = "192.168.56.78"

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.provision :shell, path: "bootstrap.sh"
   config.vm.network "private_network", ip: IP_ADDRESS
   config.vm.synced_folder ".", "/vagrant", :owner =>"www-data"
   config.vm.provider "virtualbox" do |vb|
     vb.memory = "4096"
   end
   
#   config.trigger.after :up do |trigger|
#     trigger.info = "Point browser at: 192.168.56.78"
#   end
   config.vm.post_up_message = "Point browser at: #{IP_ADDRESS}, i.e. firefox #{IP_ADDRESS}"
end
