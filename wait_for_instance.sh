#!/bin/bash

public_ip=$1

echo "Starting wait_for_instance.sh script..."
echo "Public IP: $public_ip"

###################   Wait for the instance to be reachable via SSH   ###################
while ! nc -z $public_ip 22; do
  echo "Waiting for instance to be reachable via SSH..."
  sleep 10
done

echo "Instance is reachable via SSH."
echo "Running configure_router.py script..."
python3 configure_router.py $public_ip