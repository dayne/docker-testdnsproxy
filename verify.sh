#!/bin/bash
#
#set -x

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function check_proxy() {
  curl whoami.localhost > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "${green}curl whomai.localhost worked - the nginx proxy functioning${reset}"
    echo "GREAT HAPPYNESS - ALL IS GOOD!"
  else
    echo "${red}curl whoami.localhost failed - double check you have run ${yellow}docker-compose up${reset}"
  fi
}

check_proxy
