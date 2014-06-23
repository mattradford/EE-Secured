#!/bin/bash
# server setup script for 512MB DO Droplet
# assumes you're running this as root

echo "Setting up server"

# update package list & upgrade system
echo "Updating APT & doing any system upgrades. Hang on..."
apt-get update &>> /dev/null
apt-get upgrade

# add 1GB swap
# https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04

sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab

# swap done
echo "Swap created and enabled"

# add nightly security updates
# http://blog.vigilcode.com/2011/04/ubuntu-server-initial-security-quick-secure-setup-part-i/
# http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers

# unattended-upgrades is pre-installed on 14.04, so the next line is not needed
# apt-get install unattended-upgrades

#	For reference, etc/apt/apt.conf.d/50unattended-upgrades needs to be as below
#	Unattended-Upgrade::Allowed-Origins {
#        "${distro_id}:${distro_codename}-security";
#	// "${distro_id}:${distro_codename}-updates";
#	// "${distro_id}:${distro_codename}-proposed";
#	// "${distro_id}:${distro_codename}-backports";
# };

# alter /etc/apt/apt.conf.d/10periodic
s1="Download-Upgradeable-Packages \"0\""
s2="Download-Upgradeable-Packages \"1\""
sed -i "s/$s1/$s2/g" /etc/apt/apt.conf.d/10periodic
s3="AutocleanInterval \"0\""
s4="AutocleanInterval \"7\""
sed -i "s/$s3/$s4/g" /etc/apt/apt.conf.d/10periodic
echo "APT::Periodic::Unattended-Upgrade \"1\";" >> /etc/apt/apt.conf.d/10periodic

# unattended upgrades configured
echo "unattended-upgrades configured"

# install and configure EasyEngine
curl -sL rt.cx/ee | sudo bash
ee system install

# alter SSH login 
s5="Port 22"
s6="Port "
s7=$(shuf -i 2000-65000 -n 1)
sed -i "s/$s5/$s6$s7/g" /etc/ssh/sshd_config
s8="PermitRootLogin yes"
s9="PermitRootLogin without-password"
sed -i "s/$s8/$s9/g" /etc/ssh/sshd_config
echo "AllowUsers root www-data" >> /etc/ssh/sshd_config

#restart sshd
service ssh restart

#install and configure ufw
apt-get install ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow $s7
ufw allow www
ufw allow https
# allow outgoing mail only, not ufw allow mail
ufw allow 25
ufw allow mysql
ufw allow smtp
# allow DNS for Postfix lookups
ufw allow 53

#allow CloudFlare IPs
ufw allow from 204.93.240.0/24
ufw allow from 204.93.177.0/24
ufw allow from 199.27.128.0/21
ufw allow from 173.245.48.0/20
ufw allow from 103.21.244.0/22
ufw allow from 103.22.200.0/22
ufw allow from 103.31.4.0/22
ufw allow from 141.101.64.0/18
ufw allow from 108.162.192.0/18
ufw allow from 190.93.240.0/20
ufw allow from 188.114.96.0/20
ufw allow from 197.234.240.0/22
ufw allow from 198.41.128.0/17
ufw allow from 162.158.0.0/15

# enable ufw
ufw enable

# ufw installed
echo "UFW installed and enabled"

### install fail2ban

apt-get install fail2ban

# download fail2ban wp-login config and write it to a new file
wget https://raw.githubusercontent.com/mattradford/EE-Secured/master/nginx-wp-login.conf
mv nginx-wp-login.conf /etc/fail2ban/filter.d/nginx-wp-login.conf
chmod 644 /etc/fail2ban/jail.local

# download customised jail.local
wget https://raw.githubusercontent.com/mattradford/EE-Secured/master/jail.local
mv jail.local /etc/fail2ban/jail.local
chmod 644 /etc/fail2ban/jail.local

# set fail2ban ssh port
sed -i "s/sshrandport/$s7/g" /etc/fail2ban/jail.local

# restart fail2ban
service fail2ban restart

# add default server
wget https://raw.githubusercontent.com/mattradford/EE-Secured/master/default
mv default /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# add default server page
wget https://raw.githubusercontent.com/mattradford/EE-Secured/master/index.php
mv index.php /usr/share/www
rm /usr/share/www/index.html

# reload nginx
service nginx reload

# and we're done!
s10=$(hostname  -I | cut -f1 -d' ')
echo "$(tput setaf 1)Now log in using a new terminal and the following command:$(tput sgr 0)"
echo "$(tput setaf 1)ssh -p $s7 root@$s10$(tput sgr 0)"