# docker-devdns

Needing a development DNS for your docker stuff? Me too!

https://adrianperez.org/improving-dev-environments-all-the-http-things/

Converted that and added some spice to make a docker-compose solution.

## Overview

* Runs a dockerized DNS server on port 53535 that resolves \*.test as 127.0.0.1
* Runs a nginx proxy on port 127.0.0.1:80 that is magically configured against
  running docker services.

### usage

* git clone this repo
* `docker-compose up`
* configure resolver to use docker dns for resolving \*.test as 127.0.0.1
  * On Mac:  `./osx-setup.sh` see if you get green happy
  * On Windows: ???
  * On Linux: ???
* adjust your other docker-compose things 
* launch those modified docker-compose things
* check out what the proxy is seeing/offering: `./config_summary.sh`
* step 3: PROFIT

### adjusting things

Adjust your `docker-compose.yml` as needed.  Key bits are shown below to
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

Then you will need to append the following to all the related
`docker-compose.yml` or into `docker-compose.local.yml` files.
See https://github.com/jwilder/nginx-proxy/issues/729 for the 
inspiring quotes.

```
networks:
  default:
    external:
      name: nginx-proxy
```


### linux

https://gist.github.com/marek-saji/6808114
