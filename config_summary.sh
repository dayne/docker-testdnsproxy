#!/bin/sh
docker run -it  -v /var/run/docker.sock:/tmp/docker.sock:ro -v `pwd`:/etc/docker-gen/templates jwilder/docker-gen /etc/docker-gen/templates/yaml.tmpl
