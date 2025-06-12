#!/bin/bash

# Docker Run Command Reference
# ---------------------------

# Running a Node container in interactive detached mode
docker run -it -d node
# Container will not shut down immediately, will keep listening for inputs

# Execute commands in a running container
docker exec -it peaceful_chatelet npm init

# Run Node container with volume mount and execute npm init
docker run -it -v $(pwd):/app node-utility npm init

# Install package using custom Node image with volume mount
docker run -it -v $(pwd):/app mynpm install express --save

# Docker Compose Command Reference
# -------------------------------

# Run a specific command in a service container
docker-compose run containerName command

# Example: Initialize Node project
docker-compose run node-react init

# Run command and remove container afterwards
docker-compose run --rm node-react init

# Start specific services in detached mode
docker-compose up -d server1 server2 ...

# Start service with its dependencies
docker-compose up -d server
# If this server has depends_on, it'll run them automatically

# Create Laravel project using Composer
docker-compose run --rm composer create-project --prefer-dist laravel/laravel .
# The dot specifies where to create the project (in this case root => /etc/www/html)

# Rebuild and start service
docker-compose up -d --build server
# Rebuilds image if something changed before starting

# Dockerfile Command Behavior
# --------------------------

# If we have a command after (e.g., docker run ... npm init), it'll override the CMD
# inside the Dockerfile. But with ENTRYPOINT ["npm"], it will:
# 1. Restrict commands to just npm + arguments (won't allow node + ...)
# 2. Prefix 'npm' to your specified commands (e.g., 'install' becomes 'npm install')

# We can override instructions specified in Dockerfile in docker-compose

# Volume Configuration
# -------------------
# Example with delegated option:
# volumes:
#   - ./src:/var/www/html:delegated
# 'delegated' is optional - means writes to container may not be instant for optimization

# Build Configuration
# ------------------
# build:
#   context: .
#   dockerfile: dockerfiles/nginx.Dockerfile
# We use dot as context because the image copies both nginx & src folders
# If context was set to dockerfiles folder, these folders wouldn't be reachable

# Nginx-PHP Communication
# ----------------------
# In nginx config: fastcgi_pass php:9000;
# 'php' here is the container name (could be an address like http://php:9000)
# In compose environment, services can communicate using container names
# php:9000 means the PHP service will talk to nginx on port 9000

# Composer Entrypoint Example
# --------------------------
# ENTRYPOINT [ "composer" , "--ignore-platform-reqs" ]
# This will ignore platform requirement checks if you have dependency mismatches

# Advanced Build Commands
# ----------------------

# Build with specific Dockerfile
docker build -f Dockerfile.prod -t my-image .

# Build specific target/stage from multi-stage Dockerfile
docker build --target build -f Dockerfile.prod -t my-stage-image .
