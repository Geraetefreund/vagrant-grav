#! /bin/bash

# Provisioning File for vagrant using apache2 and grav
# version 0.5 (2025-03-15)
# PHP8.3 for Grav >1.7
# neovim
# added support for page-stats plugin, needs database

# Repositories
add-apt-repository ppa:ondrej/php
add-apt-repository ppa:ondrej/apache2
add-apt-repository ppa:neovim-ppa/unstable

# Install Apache and modules required to run Grav
apt update
apt install -y apache2
a2enmod rewrite

# Install PHP and modules required to run Grav
apt -y install php8.3 libapache2-mod-php8.3
systemctl restart apache2.service
apt -y install php8.3-mbstring php8.3-gd php8.3-curl php8.3-xml
apt -y install php8.3-zip php8.3-opcache php8.3-apcu
apt -y install php8.3-yaml php8.3-xdebug

# Admin Page wouldn't load into Dashboard
# workaround: call admin/themes/ and it worked
# Page-Stats Plugin was the problem.
apt -y install php8.3-sqlite3 php8.3-mysql
phpenmod pdo pdo_sqlite pdo_mysql

# Install Ruby and build essentials
apt -y install ruby-full build-essential ruby
gem install sass

# Install essential packages for convenience
apt install -y zsh neovim htop tmux

# Configure zsh, copy config and chsh
cp /vagrant/.zshrc /home/vagrant
chsh -s /usr/bin/zsh vagrant

# Unpack VIM config
tar xfz /vagrant/nvim-cfg.tgz -C /home/vagrant

# Copy tmux config 
cp /vagrant/.tmux.conf /home/vagrant

# Install SSH public key   WHY???
#cat /vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

# Link local grav files to VM apache
if ! [ -L /var/www/html ]; then
  rm -rf /var/www/html
  ln -fs /vagrant/grav /var/www/html
fi

# Install virtual host config
VHOST=$(cat <<EOF
<VirtualHost *:80>
  DocumentRoot /var/www/html

  <Directory /var/www/html>
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog /var/log/apache2/error.log
  CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# Restart Apache one final time to pick up config changes
systemctl restart apache2.service
