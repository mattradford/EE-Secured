#!/bin/bash -x
# server setup script for 512MB DO Droplet

echo "Setting up server"

# update package list
apt-get update
echo "Updated APT"

# add 1GB swap
# https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04

sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab

# swap done
echo "Swap created and enabled"

#install and configure ufw
apt-get install ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 25002
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

### install fail2ban

apt-get install fail2ban

# copy jail.local
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# download fail2ban config and write it to a new file
wget https://raw.githubusercontent.com/mattradford/EE-Secured/master/nginx-req-limit.conf
echo > /etc/fail2ban/filter.d/nginx-req-limit.conf
cat nginx-req-limit.conf >> /etc/fail2ban/filter.d/nginx-req-limit.conf

# remove downloaded file
rm nginx-req-limit.conf 

# restart fail2ban
service fail2ban restart

# install and configure EasyEngine
curl -sL rt.cx/ee | sudo bash
ee system install

# and we're done!
echo "All Done!"