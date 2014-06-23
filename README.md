EE-Secured
==========

Install script and files for a secure server using rtcamp's [EasyEngine](https://github.com/rtCamp/easyengine/), based on Ubuntu 14.04 x64.

Intended for a 521MB DigitalOcean droplet, but can be used for any VPS.

The script:

* updates APT
* installs curl (if required)
* adds 1GB swap
* adds UFW
⋅⋅* configures rules
⋅⋅* whitelists CloudFlare IP Ranges


