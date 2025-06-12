#!/bin/bash

# Docker Compose Reference Script
# ------------------------------

# When you bring your services down in compose, containers will be removed by default

# Version specification
version: "3.8" # or your preferred version
# The version tells Docker which file specification to use to execute your commands correctly
# This is similar to how React 15 differs from React 17
# The children of the services are the containers themselves

# YAML syntax notes:
# - If you have key: value, you don't need dashes (-)
# - For lists like environment files, you need dashes:
#   - ./env/mongo.env

# Networking in Compose:
# When using compose, you don't need --network
# All services will automatically be connected to a default network
# You can add custom networks if needed:
networks:
my-network:
driver: bridge

# Service naming in Compose:
# Even though services created by compose have generated names (e.g., mongodb => 6-compose-backend-1)
# You can still reference them by their service name:
# mongodb://${process.env.MONGODB_USERNAME}:${process.env.MONGODB_PASSWORD}@mongodb:27017/course-goals?authSource=admin
# The @mongodb reference uses the service name, not the generated container name

# Environment variables examples:
environment:
MONGO_INITDB_ROOT_USERNAME: max # Inline definition
MONGO_INITDB_ROOT_PASSWORD: secret

# Or using env file:
env_file:
- ./env/mongo.env

# Build configuration examples:
build: ./backend # Simple form

# Or detailed build configuration:
build:
context: ./backend # Refers to COPY . . in Dockerfile
dockerfile: Dockerfile-dev
args:
password: 12345678

# Service dependencies:
depends_on:
- mongodb
# If you're in the react service (container), this means it should run
# after the mongodb service starts (note: can depend on multiple services)

# Interactive mode equivalent:
stdin_open: true # -i equivalent
tty: true        # -t equivalent

# Force a specific container name:
container_name: mongodb

# Common Docker Compose Commands:
# Start services in detached mode
docker-compose up -d

# Stop and remove containers
docker-compose down

# Stop and remove containers plus volumes
docker-compose down -v

# Force rebuild and start
docker-compose up --build
# Forces the Dockerfile to be rebuilt. Without --build, compose will use the old image
# even if the Dockerfile has changed

# Just build images without starting:
docker-compose build
# Looks for any missing build images and builds them if they don't exist
