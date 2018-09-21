# docker-devdns

Needing a development DNS for your docker stuff? Me too!

https://adrianperez.org/improving-dev-environments-all-the-http-things/

Converted that and added some spice to make a docker-compose solution.

## Overview

* Runs a dockerized DNS server on port 53535 that resolves \*.test as 127.0.0.1
* Runs a nginx proxy on port 127.0.0.1:80 that is magically configured against
  running docker services.

### Using the thing

* git clone this repo
  * `git clone https://github.com/dayne/docker-testdnsproxy.git`
* Launch the docker stuff `docker-compose up`
* Configure resolver to use docker dns for resolving `*.test` to `127.0.0.1`
  * On Mac:  `./osx-setup.sh` 
  * On Windows: `???`
  * On Linux: `???`
* Adjust your other docker-compose things _details below_
* Launch those modified docker-compose things
* Bonus Points - Check out what the proxy is seeing & offering: 
  `./config_summary.sh`
* _step 3: PROFIT_

### Adjusting your things

Adjust your `docker-compose.yml` as needed.  The key bits are shown below to
cause a port 8080 to be exposed and show up as example.test

```
services:
  SERVICE_NAME:
    expose:
      - 8080
    environment:
      - VIRTUAL_HOST=example.test
    network_mode: "bridge"
```

#### bridge mode alternative adjustment

If bridge mode isn't viable then you might try using a 
local docker network called `nginx-proxy`.  

Create it using 

`docker network create nginx-proxy`

Then append the following networks block into your related `docker-compose.yml` or into `docker-compose.local.yml` files.

See https://github.com/jwilder/nginx-proxy/issues/729 for the inspiring quotes.

```
networks:
  default:
    external:
      name: nginx-proxy
```

## DNS on Linux

### Ubuntu 18.04

Name resolution in Ubuntu has been a changing landscape the last few years.  Fortunately Pim on askubuntu figured out how to [set up local wildcard resolution in 18-04](https://askubuntu.com/questions/1029882/how-can-i-set-up-local-wildcard-127-0-0-1-domain-resolution-on-18-04). Steps below for making sure we take advantage of our docker dnsmasq image that does one thing only.

add the `dns=dnsmasq` to the `/etc/NetworkManager/NetworkManager.conf`

```
sudo rm /etc/resolv.conf 
sudo ln -s /var/run/NetworkManager/resolv.conf /etc/resolv.conf
echo 'server=/test/127.0.0.1#53535' | sudo tee /etc/NetworkManager/dnsmasq.d/test-wildcard.conf
sudo systemctl reload NetworkManager
```

Successful test should look like:
```
$ dig +short wibbles.test
127.0.0.1
```
