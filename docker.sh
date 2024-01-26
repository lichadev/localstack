#!/bin/bash
DOCKER_USER=$1
DOCKER_PASS=$2

# check if docker is installed
function docker_check {
  if [ ! -x "$(command -v docker)" ]; then
    echo 'Error: docker is not installed.' >&2
    exit 1
  fi
  #log into a docker account
  docker login -u $DOCKER_USER -p $DOCKER_PASS
  docker pull localstack/localstack:latest
  if [ ! $? -eq 0 ]; then
    echo "Error: docker image localstack/localstack:latest not found"
    exit 1
  fi
  docker create container -p 4566:4566 -p 4510-4559:4510 -p 8080:8080 --name localstack localstack/localstack
  docker start localstack
  # check if localstack is running
  docker ps | grep localstack
  if [ ! $? -eq 0 ]; then
    echo "Error: localstack container not running"
    exit 1
  fi
}

# This could be other option if we want to use terraform via a python script
# It has it advantages but for now i will stick with terraform official cli

#function terraform_local  {
#  # check if pip is installed
#  if [ ! -x "$(command -v pip)" ]; then
#    echo 'Error: pip is not installed.' >&2
#    # Install pip ## TODO
#    exit 1
#  else
#    pip install -r requirements.txt
#    if [ $? -eq 0 ]; then
#      echo "Dependencies installed succesfully"
#      tflocal init
#    else
#      echo "Something went wrong when installing dependencies"
#    fi
#  fi
#}

docker_check
