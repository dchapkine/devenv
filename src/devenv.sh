#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# services list
AVAILABLE_SERVICES=("mongodb5" "mysql8" "redis7" "neo4j4ce")

# include package vars
for FILE in $SCRIPT_DIR/packages/*_vars.sh; do
  . $FILE
done

is_installed () {
  docker ps -a --format '{{.Names}}' | grep -Eq "^$1\$"
  return $?
}

is_running () {
  docker ps --format '{{.Names}}' | grep -Eq "^$1\$"
  return $?
}

service_check () {
  if is_running $1; then
    echo "+ $1 is running"
    service_usage $1
  elif is_installed $1; then
    echo "+ $1 is installed, use \"$0 start $1\""
  else
    echo "+ $1 not installed, use \"$0 install $1\""
  fi
}

service_usage () {
  . "$SCRIPT_DIR/packages/$1_usage.sh"
  return 0
}

service_connect_cli () {
  . "$SCRIPT_DIR/packages/$1_cli.sh"
  return 0
}

service_start () {
  docker start $1
  service_usage $1
  return 0
}

service_stop () {
  docker stop $1
  return 0
}

service_install () {
  if is_installed $1; then
    echo "+ $1 is installed"
  else
    echo "installing $1"
    . "$SCRIPT_DIR/packages/$1_install.sh"
    service_usage $1
  fi
  return 0
}


if [ "$1" = "selfupdate" ]; then
  cd $SCRIPT_DIR
  cd ..
  git pull

# Install service
elif [ "$1" = "install" ]; then
  if [[ -n $2 ]]; then
    if [ "$2" = "all" ]; then
      for svc in ${AVAILABLE_SERVICES[@]}; do
        service_install $svc
      done
    else
      service_install $2
    fi
  else
    echo "USAGE: \"$0 install SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$0 install $svc"
    done
    echo "$0 install all #will install all services"
  fi

# Start a service
elif [ "$1" = "start" ]; then
  if [[ -n $2 ]]; then
    echo "starting $2"
    service_start $2
  else
    echo "USAGE: \"$0 start SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$0 start $svc"
    done
  fi

# Stop service
elif [ "$1" = "stop" ]; then
  if [[ -n $2 ]]; then
    echo "stopping $2"
    service_stop $2
  else
    echo "USAGE: \"$0 stop SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$0 stop $svc"
    done
  fi

# Connect to a service (cli)
elif [ "$1" = "cli" ]; then
  if [[ -n $2 ]]; then
    echo "connecting to $2 cli"
    service_connect_cli $2
  else
    echo "USAGE: \"$0 cli SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$0 cli $svc"
    done
  fi

# Usage
else
  echo ""
  echo "$0"
  echo ""
  for svc in ${AVAILABLE_SERVICES[@]}; do
    service_check $svc
    echo ""
  done
fi




# LINKS
# - https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers

