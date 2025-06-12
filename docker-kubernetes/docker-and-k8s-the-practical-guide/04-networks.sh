#!/bin/bash

# Docker Network Management Commands
docker network ls      # List all networks
docker network rm      # Remove one or more networks
docker network prune   # Remove all unused networks
docker network create  # Create a new network
docker network connect # Connect a container to a network

# Instead of:
# mongodb://localhost:27017/swfavorites
# Use:
mongodb://host.docker.internal:27017/swfavorites

# host.docker.internal is understood by Docker and will be translated to the URL of
# the local host machine as seen inside the container (note you can use http instead
# of mongodb). This is for communication between your dockerized apps and your local host machine.

# Alternative (not recommended for dynamic environments):
mongodb://172.17.0.3:27017/swfavorites
# 172.17.0.3 is IP of the mongodb container, obtained by inspecting the container
# This way we communicate with another container

# The previous way is not the easiest way - we need to lookup network IP for each container.
# The solution is to create a DOCKER NETWORK, which will automatically resolve names for
# all containers within this network. Unlike volumes which are created automatically,
# you need to explicitly create a network with your chosen name.

# Create a custom network
docker network create favorites-net

# Run MongoDB in the network
docker run -d --name mongodb --network favorites-net mongo

# Run your application in the same network
docker run -p 3000:3000 --name favorites -d --rm --network favorites-net favorites

# Now instead of:
# mongodb://172.17.0.3:27017/swfavorites
# You can use:
# mongodb://mongodb:27017/swfavorites
# Just like host.docker.internal, Docker will automatically resolve the container name to its IP

# Important note: When working with MongoDB, if you change the credentials for a DB username,
# you need to remove the old volumes and recreate them because the old credentials will
# still be stored in them.

# About Dockerfile COPY:
# RUN npm install \ COPY . .
# Note: The node_modules will be copied from local host to the container because of
# the . . which copies everything including node_modules
# The solution is simple - exclude them in .dockerignore file

# Example MongoDB container with authentication
docker run --name mongodb --rm -d \
  --network goals-net \
  -v data:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=ahmadkhatib \
  -e MONGO_INITDB_ROOT_PASSWORD=12345678 \
  mongo

# Example React application with volume mount
docker run -p 3000:3000 \
  --name goals-react \
  --rm -it \
  -v "$(pwd)/src:/app/src" \
  goals-react
