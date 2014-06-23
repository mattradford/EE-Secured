EE-Secured
==========

Install script and files for a secure WordPress server using rtcamp's [EasyEngine](https://github.com/rtCamp/easyengine/), based on Ubuntu 14.04 x64.

Intended for a 521MB DigitalOcean droplet, but can be used for any VPS with modification.

The script:

* updates APT
* installs curl (if required)
* changes default SSH port and allows only key-based login
  * (assumes that a key has already been added to the server during droplet creation)
* adds & enables 1GB swap
* adds & enables UFW
  * configures rules
  * whitelists CloudFlare IPIP Ranges
* configures unattended security updates
* installs fail2ban
* installs EasyEngine
* alters default web page for server to show the hostname

Personally, I then log in to the server again using a key & the new port and check everything is correct. Then I alter EasyEngine's conf file (`/etc/easyengine`).

The server is then ready for `ee site create` command to start adding WordPress sites.

## TO DO
* automate [CloudFlare IPv4 range addition](https://www.cloudflare.com/ips-v4)

## License

[GPL] (http://www.gnu.org/licenses/gpl-2.0.txt).