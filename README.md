EE-Secured
==========

Install script and files for a secure WordPress server using rtcamp's [EasyEngine](https://github.com/rtCamp/easyengine/).

Intended for a 512MB DigitalOcean droplet running Ubuntu 14.04 x64, but can be used for any VPS with modification.

The script:

* updates APT & upgrades system
* adds & enables 1GB swap
* configures unattended security updates
* installs EasyEngine
* changes default SSH port to a random one and allows only key-based login
  * (assumes that a key has already been added to the server during droplet creation)
* adds & enables UFW
  * configures rules, including randomly assigned SSH port
  * whitelists CloudFlare IPv4 Ranges
* installs fail2ban with [WP brute force protection](http://abdussamad.com/archives/616-Stop-Brute-Force-WordPress-Login-Attempts-with-Fail2Ban.html)
  * fail2ban active on the random SSH port
* changes the default server page to show the hostname
* prints the ssh command to access the new server

In order to run the script, create a new droplet, SSH into it, then:

* `wget https://raw.githubusercontent.com/mattradford/EE-Secured/master/do-install.sh`
* `chmod +x do-install.sh`
* `./do-install.sh`

You will need to answer some prompts as the script runs.

After the script has run, log in to the server again using a new terminal to check everything is correct. Then alter EasyEngine's conf file (`/etc/easyengine/ee.conf`) to suit your defaults.

The server is then ready for `ee site create` to start adding WordPress sites.

## To Do
* allow user to enter EE config choices
* automate [CloudFlare IPv4 range addition](https://www.cloudflare.com/ips-v4)

## License

[GPL] (http://www.gnu.org/licenses/gpl-2.0.txt).