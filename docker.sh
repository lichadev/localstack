#!/bin/bash
# check if docker is installed
function docker_check {
  if [ ! -x "$(command -v docker)" ]; then
      echo 'Error: docker is not installed.' >&2
      # Install docker ## TODO
      exit 1
  else 
    docker pull localstack/localstack:latest
    if [ $? -eq 0 ]; then
      echo "Docker image localstack/localstack:latest downloaded succesfully"
      docker create container -p 4566:4566 -p 4510-4559:4510 -p 8080:8080 --name localstack localstack/localstack
      docker start localstack
      # check if localstack is running
      docker ps | grep localstack
      if [ $? -eq 0 ]; then 
        echo "Localstack started"
      else
        echo "Something went wrong when starting localstack container"
    else
      echo "Something went wrong when creating localstack container"
    fi 
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