#!/bin/bash
#
# want to trace activity of this script while it runs? uncomment following line
#set -x

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function check_test_dns() {
  ping_state=false
  ping -t 1 -c 1 anything.test > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "${green}anything.test responded to ping${reset}"
    ping_state=true
  else
    echo "${red}anything.test did not respond to ping${reset}"
  fi

  dig_state=false
  dig @127.0.0.1 -p 53535 anything.test > /dev/null  2>&1
  if [ $? -eq 0 ]; then
    echo "${green}dig anything.test resolved${reset}"
    dig_state=true
  else
    echo "${red}dig anything.test failed to resolv${reset}"
  fi

  if [[ $ping_state == true ]] && [[ $dig_state == true ]]; then
    echo "${green}resolving .test working perfectly${reset}"
    return 0
  else
    echo "${failed}resolving .test not yet working${reset}"
    return 1
  fi
}

function check_proxy() {
  curl whoami.test > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "${green}curl whomai.test worked - the nginx proxy functioning${reset}"
    echo "GREAT HAPPYNESS - ALL IS GOOD!"
  else
    echo "${red}curl whoami.test failed - double check you have run ${yellow}docker-compose up${reset}"
  fi
}

function setup_osx() {
  if [ ! -d /etc/resolver ]; then
    echo "${green}/etc/resolver/ missing - creating the directory${reset}"
    sudo mkdir -v /etc/resolv
  else
    echo "/etc/resolver/ exists already - skipping creation"
  fi

  if [ ! -f /etc/resolver/test-wildcard ]; then
    echo "${green}/etc/resolver/test-wildcard missing - copying out test copy${reset}"
    sudo cp -v etc_resolver_test /etc/resolver/test-wildcard
  else
    echo "/etc/resolver/test-wildcard exists already -- nothing done"
  fi
}

check_test_dns
if [ $? -eq 0 ]; then
  echo "It appears /etc/resolver/test is already setup and working as we want."
  check_proxy
  exit 0
else
  echo setup_osx
fi

echo "####  post setup test"
check_test_dns
if [ $? -eq 0 ]; then
  echo "Everything is working great - congradulations"
else
  echo "Are you sure you started the docker-dnsdev service?  Try running ${yellow}docker-compose up${reset}"
fi
