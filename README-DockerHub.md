# Docker Hub Deployment Guide

## Prerequisites

1. **Docker Hub Account**: Create an account at [hub.docker.com](https://hub.docker.com)
2. **Docker CLI**: Make sure Docker is installed and running
3. **Login to Docker Hub**: Run `docker login` and enter your credentials

## Quick Start

### 1. Update Docker Hub Username

Edit the `push-to-dockerhub.sh` script and replace `your-dockerhub-username` with your actual Docker Hub username:

```bash
# Replace this line in push-to-dockerhub.sh
DOCKER_HUB_USERNAME="your-actual-username"
```

### 2. Build and Push Images

Run the push script:

```bash
./push-to-dockerhub.sh
```

This will:
- Build all three Docker images
- Tag them with your Docker Hub username
- Push them to Docker Hub

### 3. Deploy from Docker Hub

Use the production Docker Compose file:

```bash
# Update docker-compose.prod.yml with your username first
docker-compose -f docker-compose.prod.yml up -d
```

## Manual Commands

If you prefer to run commands manually:

### Build and Tag Images

```bash
# Java Backend
docker build -t your-username/ncc2025-java-backend:latest -f backend2/Dockerfile backend2/

# Node.js Backend  
docker build -t your-username/ncc2025-nodejs-backend:latest -f backend2/Dockerfile.nodejs backend2/

# Frontend
docker build -t your-username/ncc2025-frontend:latest -f frontend2/Dockerfile frontend2/
```

### Push to Docker Hub

```bash
docker push your-username/ncc2025-java-backend:latest
docker push your-username/ncc2025-nodejs-backend:latest
docker push your-username/ncc2025-frontend:latest
```

## Image URLs

After pushing, your images will be available at:
- `https://hub.docker.com/r/your-username/ncc2025-java-backend`
- `https://hub.docker.com/r/your-username/ncc2025-nodejs-backend`
- `https://hub.docker.com/r/your-username/ncc2025-frontend`

## Usage

Anyone can now pull and run your application:

```bash
# Pull the images
docker pull your-username/ncc2025-java-backend:latest
docker pull your-username/ncc2025-nodejs-backend:latest
docker pull your-username/ncc2025-frontend:latest

# Run with Docker Compose
docker-compose -f docker-compose.prod.yml up -d
```

## Ports

- Frontend: http://localhost:80
- Java Backend: http://localhost:8080
- Node.js Backend: http://localhost:5000
