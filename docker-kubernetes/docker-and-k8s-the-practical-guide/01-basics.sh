# Execute container with interactive terminal
docker run -it node

# Map port 3000 (external) to port 80 (internal)
docker run -p 3000:80 [image]

# Run with port mapping and auto-remove container after stopping
docker run -p 8000:80 --rm [image]

# Run container in detached mode (background)
docker run -p 8000:80 -d [image]

# Run with custom name, port mapping, detached mode and auto-remove
docker run -p 8000:80 -d --rm --name marketApp [image/image:tag]

# Start an existing container
docker start [name]

# Start container in attach mode with interactive terminal
docker start -a -i [name]

# Reattach to a running container
docker attach [name]

# View container logs (-f for follow)
docker logs [name]

# Show all containers (running and stopped)
docker ps -a

# Show only running containers
docker ps

# List all images (must remove dependent containers first)
docker images

# Build image from Dockerfile in current directory
docker build .

# Build and tag an image
docker build -t name:latest .

# Stop a running container
docker stop [containerId]

# Remove specific containers
docker rm [name name ...]

# Remove all stopped containers
docker container prune

# Remove specific images
docker rmi [image image ...]

# Remove all unused images
docker image prune

# Remove all images including tagged ones
docker image prune -a

# Show detailed image information
docker image inspect [image]

# Copy files/folders between host and container
docker cp source-folder/. containerName:/destination-folder

# Tag an image for pushing to remote repository
docker tag localImage:latest ahmadkh007/remote-repository
