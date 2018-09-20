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
