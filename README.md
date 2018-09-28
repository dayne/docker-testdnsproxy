# docker-testdnsproxy

Docker composition for a _wildcard_ `*.localhost` domain docker aware web proxy!

Needing a development DNS for your docker stuff? Me too! 

This project inspired by [iMichael's give your dev environment an identity](https://medium.com/@iMichael/give-your-dev-environment-an-identity-490bc25c9dd1) post that reminded me .dev is OUT and .test is IN .. and pointed me in direction to find [Adrian Perez improving dev environments](https://adrianperez.org/improving-dev-environments-all-the-http-things/) post that described what I wanted with docker bits.

This project is that inspiration has been baked and spiced to make a docker-compose solution to give myself a docker aware wildcard `*.localhost` web proxy.

## Overview

* Runs a nginx proxy on port 127.0.0.1:80 that is magically configured against running docker services.

## Using it
Just three easy steps:

1) compose up
2) add a few bits to your existing docker-compose.yml file 
  * `network_mode=bridge`
  * `expose` ports
  * `VIRTUAL\_HOST=name.localhost`
3) profit

### Actual details on the things

* git clone this repo
  * `git clone https://github.com/dayne/docker-testdnsproxy.git`
* Launch the docker stuff `docker-compose up`
* Adjust your other docker-compose files with extra attributes
* Launch those modified docker-compose things
* Bonus Points - Check out what the proxy is seeing & offering: 
  `./config_summary.sh`
* _PROFIT_

### Adjusting your things

Adjust your `docker-compose.yml` as needed.  The key bits are shown below to
cause a port 8080 to be exposed and show up as `http://example.localhost/`

```
services:
  SERVICE_NAME:
    expose:
      - 8080
    environment:
      - VIRTUAL_HOST=example.localhost
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
