# vagrant-grav
Grav >=1.7 dev environment: virtualbox, bento/ubuntu22-04, apache, php8.3, ruby, sass, zsh, neovim, tmux 
extract grav skeleton into /vagrant/grav/ \
https://getgrav.org/downloads \
unzip grav-admin-v1.7.42.1.zip \
mv grav-admin/ grav/ \
vagrant up \
vagrant ssh

## directory permissions after extracting a grav backup
inside the folder /vagrant, execute:
``` find grav -type d -exec chmod 775 {} +```
to make them look prettier (they are very ugly greenish otherwise)


## had to change vagrant box
Seems like ppa:ondrej/php does not support trusty 18.04 any longer.
Added bento/ubuntu-22.04 and that to work fine.

## remember to use sudo when in vagrant ssh
bin/gpm and such need to be run as sudo.

## when running inside a virtual machine
make sure to enable either Intel VT-x/EPT or AMD-V/RVI virtualization engine

## Error when not in vboxusers group
There was an error while executing VBoxManage, a CLI used by Vagrant for controlling VirtualBox. The command and stderr is shown below.

```Command: ["hostonlyif", "create"]```

Solution: Add vboxusers in sudo group

```sudo gpasswd -a mark vboxusers```

And remember to log out and log in once to apply changes!
