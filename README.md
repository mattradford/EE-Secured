EE-Secured
==========

Install script and files for a secure WordPress server using rtcamp's [EasyEngine](https://github.com/rtCamp/easyengine/), based on Ubuntu 14.04 x64.

Intended for a 512MB DigitalOcean droplet, but can be used for any VPS with modification.

The script:

* updates APT
* adds & enables 1GB swap
* adds & enables UFW
  * configures rules
  * whitelists CloudFlare IPIP Ranges
* configures unattended security updates
* installs fail2ban
* installs EasyEngine

In order to run the script, create a new droplet, SSH into it, then:

* `wget https://raw.githubusercontent.com/mattradford/EE-Secured/master/do-install.sh`
* `chmod +x do-install.sh`
* `./do-install.sh`

After the script has run, I then log in to the server again using a key & the new port and check everything is correct. Then I alter EasyEngine's conf file (`/etc/easyengine`).

The server is then ready for `ee site create` command to start adding WordPress sites.

## To Do
* change default SSH port and allow only key-based login
  * (assumes that a key has already been added to the server during droplet creation)
* configure other fail2ban rules
* alter default web page for server to show the hostname
* automate [CloudFlare IPv4 range addition](https://www.cloudflare.com/ips-v4)

## License

[GPL] (http://www.gnu.org/licenses/gpl-2.0.txt).