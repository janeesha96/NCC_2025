#!/bin/bash

# Docker Hub push script for NCC_2025 project
# Make sure you're logged into Docker Hub: docker login

# Set your Docker Hub username (replace with your actual username)
DOCKER_HUB_USERNAME="your-dockerhub-username"

# Set image tags
JAVA_BACKEND_TAG="$DOCKER_HUB_USERNAME/ncc2025-java-backend:latest"
NODEJS_BACKEND_TAG="$DOCKER_HUB_USERNAME/ncc2025-nodejs-backend:latest"
FRONTEND_TAG="$DOCKER_HUB_USERNAME/ncc2025-frontend:latest"

echo "🚀 Building and pushing images to Docker Hub..."

# Build Java Backend
echo "📦 Building Java Backend..."
docker build -t $JAVA_BACKEND_TAG -f backend2/Dockerfile backend2/

# Build Node.js Backend
echo "📦 Building Node.js Backend..."
docker build -t $NODEJS_BACKEND_TAG -f backend2/Dockerfile.nodejs backend2/

# Build Frontend
echo "📦 Building Frontend..."
docker build -t $FRONTEND_TAG -f frontend2/Dockerfile frontend2/

# Push to Docker Hub
echo "⬆️ Pushing to Docker Hub..."

echo "Pushing Java Backend..."
docker push $JAVA_BACKEND_TAG

echo "Pushing Node.js Backend..."
docker push $NODEJS_BACKEND_TAG

echo "Pushing Frontend..."
docker push $FRONTEND_TAG

echo "✅ All images pushed successfully!"
echo ""
echo "Your images are now available at:"
echo "- $JAVA_BACKEND_TAG"
echo "- $NODEJS_BACKEND_TAG"
echo "- $FRONTEND_TAG"
