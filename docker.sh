#!/bin/bash

# pass in the docker username and password as args
if [ $# -eq 0 ]; then
  echo "Error: please provide docker username and password as args"
  exit 1
fi

if [ $1 = "" ] || [ $2 = "" ]; then
  echo "Error: please provide docker username and password as args"
  exit 1
fi

# could be through .env files or even using a third language as "middle-man" to pass the credentials
# for now we will use the args
DOCKER_USER=$1
DOCKER_PASS=$2

# check if docker is installed
function docker_check {
if ! docker info >/dev/null 2>&1; then
  echo "Error: Docker is not installed or not running."
  exit 1
fi
docker login -u $DOCKER_USER -p $DOCKER_PASS
# pull localStack image
docker pull localstack/localstack:$TAG

# start localstack container
docker run -d --name localstack \
  -p 4566:4566 -p 4510-4559:4510 -p 8080:8080 \
  localstack/localstack

# check if localstack container is running
if ! docker inspect -f '{{.State.Running}}' localstack | grep true; then
  echo "Error: Localstack container not running"
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
