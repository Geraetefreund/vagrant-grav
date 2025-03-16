#!/bin/bash
#
# Provisioning File for Vagrant using Apache2 and Grav
# Version 1.0 (2025-03-16)

# Add Repositories
add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:ondrej/apache2
add-apt-repository ppa:neovim-ppa/unstable


# Install Apache and modules required to run Grav
apt update
apt install -y apache2 openssl
a2enmod rewrite ssl

# Install PHP 8.3 and modules required for Grav
apt install -y php8.3 libapache2-mod-php8.3
systemctl restart apache2.service
apt install -y php8.3-mbstring php8.3-gd php8.3-curl php8.3-xml php8.3-zip
apt install -y php8.3-opcache php8.3-apcu php8.3-yaml php8.3-xdebug 

# Grav Admin Page wouldn't load into Dashboard
# workaround: call admin/themes/ and it worked
# Page-Stats Plugin was the problem.
apt install -y php8.3-sqlite3 php8.3-mysql
phpenmod pdo pdo_sqlite pdo_mysql

# Generate Self-Signed SSL Certificate
SSL_DIR="/etc/apache2/ssl"
mkdir -p "$SSL_DIR"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$SSL_DIR/apache-selfsigned.key" \
    -out "$SSL_DIR/apache-selfsigned.crt" \
    -subj "/C=UK/ST=NONE/L=Barmytown/O=GravDev/OU=IT/CN=192.168.56.78"

# Install Ruby and build-essentrials
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

# Link local grav files to VM apache
if ! [ -L /var/www/html ]; then
  rm -rf /var/www/html
  ln -fs /vagrant/grav /var/www/html
fi

# Set Up Apache Virtual Host for HTTPS
VHOST=$(cat <<EOF
<VirtualHost *:443>
    DocumentRoot /var/www/html
    ServerName 192.168.56.78

    SSLEngine on
    SSLCertificateFile "$SSL_DIR/apache-selfsigned.crt"
    SSLCertificateKeyFile "$SSL_DIR/apache-selfsigned.key"

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default-ssl.conf

# Enable the SSL site and restart Apache
a2ensite 000-default-ssl
systemctl restart apache2.service
