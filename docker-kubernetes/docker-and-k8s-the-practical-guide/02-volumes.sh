#!/bin/bash

# Docker volume management commands
docker volume ls      # List all volumes
docker volume prune   # Remove all unused volumes
docker volume inspect # Show detailed volume info
docker volume rm      # Remove specific volume(s)

# Named volumes will not be deleted once the container is removed (unlike anonymous volumes)
docker run -d -p 8000:80 --rm --name feedback-app -v feedback:/app/feedback node-apps:latest

# This will bind mount the host directory into the container's workDir
docker run -p 8000:80 -d --name feedback-app --rm \
  -v feedback:/app/feedback \
  -v "/mnt/c/Users/Ahmad/Downloads/Programming/Programming/Docker/docker/3-data-volumes:/app" \
  feedback-node:latest

# Shortcut using %cd% instead of full path (Windows)
# docker run -p 8000:80 -d --name feedback-app --rm -v feedback:/app/feedback -v "%cd%":/app feedback-node:latest

# Added anonymous volume for node_modules to prevent overwrite by bind mount
docker run -p 8000:80 -d --name feedback-app --rm \
  -v feedback:/app/feedback \
  -v "/mnt/c/Users/Ahmad/Downloads/Programming/Programming/Docker/docker/3-data-volumes:/app" \
  -v /app/node_modules \
  feedback-node:latest

# Read-only bind mount (ro flag prevents container from writing to host files)
docker run -p 8000:80 -d --rm --name feedback-app \
  -v feedback:/app/feedback \
  -v "/mnt/c/Users/Ahmad/Downloads/Programming/Programming/Docker/docker/3-data-volumes:/app:ro" \
  -v /app/node_modules \
  -v /app/temp \
  feedback-node:1

# Using environment variables
docker run -p 8000:8000 -d --name feedback-app --rm --env PORT=8000 -v feedback:/app/feedback node-app:latest

# Using .env file for environment variables
docker run -p 8000:8000 -d --name feedback-app --rm --env-file ./.env -v feedback:/app/feedback node-app:latest

# Building with build arguments
docker build -t node-image:latest --build-arg DEFAULT_PORT=8000 .
