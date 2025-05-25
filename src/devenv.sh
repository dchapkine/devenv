#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PACKAGE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/../packages" &> /dev/null && pwd )
SCRIPT_NAME=devenv

# services list
AVAILABLE_SERVICES=()
for DIR in $PACKAGE_DIR/*; do
  AVAILABLE_SERVICES+=("$(basename $DIR)")
done

# include package vars
for DIR in $PACKAGE_DIR/*; do
  . "$DIR/vars.sh"
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
    echo "+ $1 is installed, use \"$SCRIPT_NAME start $1\""
  else
    echo "+ $1 not installed, use \"$SCRIPT_NAME install $1\""
  fi
}

service_usage () {
  . "$PACKAGE_DIR/$1/usage.sh"
  return 0
}

service_connect_cli () {
  . "$PACKAGE_DIR/$1/cli.sh"
  return 0
}


service_remove () {
  . "$PACKAGE_DIR/$1/remove.sh"
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
    . "$PACKAGE_DIR/$1/install.sh"
    service_usage $1
  fi
  return 0
}


if [ "$1" = "selfupdate" ]; then
  cd $SCRIPT_DIR
  cd ..
  git pull

elif [ "$1" = "selfinstall" ]; then
  echo "" >> ~/.bashrc
  echo "# devenv installation:" >> ~/.bashrc
  echo "alias devenv=$SCRIPT_DIR/devenv.sh" >> ~/.bashrc
  echo "" >> ~/.bashrc

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
    echo "USAGE: \"$SCRIPT_NAME install SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$SCRIPT_NAME install $svc"
    done
    echo "$SCRIPT_NAME install all #will install all services"
  fi

# Start a service
elif [ "$1" = "start" ]; then
  if [[ -n $2 ]]; then
    if [ "$2" = "all" ]; then
      for svc in ${AVAILABLE_SERVICES[@]}; do
        echo "starting $svc"
        service_start $svc
      done
    else
      echo "starting $2"
      service_start $2
    fi
  else
    echo "USAGE: \"$SCRIPT_NAME start SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$SCRIPT_NAME start $svc"
    done
  fi

# Stop service
elif [ "$1" = "stop" ]; then
  if [[ -n $2 ]]; then
    if [ "$2" = "all" ]; then
      for svc in ${AVAILABLE_SERVICES[@]}; do
        echo "stopping $svc"
        service_stop $svc
      done
    else
      echo "stopping $2"
      service_stop $2
    fi
  else
    echo "USAGE: \"$SCRIPT_NAME stop SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$SCRIPT_NAME stop $svc"
    done
  fi

# Connect to a service (cli)
elif [ "$1" = "cli" ]; then
  if [[ -n $2 ]]; then
    echo "connecting to $2 cli"
    service_connect_cli $2
  else
    echo "USAGE: \"$SCRIPT_NAME cli SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$SCRIPT_NAME cli $svc"
    done
  fi

# Connect to a service (ssh)
elif [ "$1" = "ssh" ]; then
  if [[ -n $2 ]]; then
    echo "ssh to $2"
    service_connect_cli $2
  else
    echo "USAGE: \"$SCRIPT_NAME ssh SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$SCRIPT_NAME cli $svc"
    done
  fi

# remove the service
elif [ "$1" = "rm" ]; then
  if [[ -n $2 ]]; then
    echo "removing $2"
    service_remove $2
  else
    echo "USAGE: \"$SCRIPT_NAME rm SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$SCRIPT_NAME rm $svc"
    done
  fi
  
elif [ "$1" = "remove" ]; then
  if [[ -n $2 ]]; then
    echo "removing $2"
    service_remove $2
  else
    echo "USAGE: \"$SCRIPT_NAME rm SERVICE_NAME\""
    for svc in ${AVAILABLE_SERVICES[@]}; do
      echo "$SCRIPT_NAME rm $svc"
    done
  fi

# Usage
else
  echo ""
  echo "USAGE $SCRIPT_NAME"
  echo "==="
  echo "$SCRIPT_NAME install PACKAGE_NAME|all # installs package"
  echo "$SCRIPT_NAME start PACKAGE_NAME|all # starts package service"
  echo "$SCRIPT_NAME stop PACKAGE_NAME|all # stops package service"
  echo "$SCRIPT_NAME cli PACKAGE_NAME # ssh into service container"
  echo "$SCRIPT_NAME ssh PACKAGE_NAME # ssh into service container"
  echo "$SCRIPT_NAME rm PACKAGE_NAME|all # removes package"
  echo "$SCRIPT_NAME selfupdate # pulls latest version of this script from git"
  echo "./$SCRIPT_NAME selfinstall # adds script path to session PATH (you need to source ~/.bashrc after that)"
  echo ""
  echo "PACKAGES:"
  echo "==="
  for svc in ${AVAILABLE_SERVICES[@]}; do
    service_check $svc
  done
fi




# LINKS
# - https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers

