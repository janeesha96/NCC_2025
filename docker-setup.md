# Complete Docker Setup for NCC_2025 Project

## Project Structure
- **Java Backend**: Spring Boot application (port 8080)
- **Node.js Backend**: Express server (port 5000)  
- **Frontend**: HTML with nginx (port 80)

---

## 1. Dockerfile for Java Backend
**File: `backend2/Dockerfile`**
```dockerfile
# Use OpenJDK 17 as base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy Maven files first for better layer caching
COPY pom.xml .
COPY src ./src

# Install Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Build the application
RUN mvn clean package -DskipTests

# Expose port 8080
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "target/demo-1.0.0.jar"]
```

---

## 2. Dockerfile for Node.js Backend
**File: `backend2/Dockerfile.nodejs`**
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY server.js .

EXPOSE 5000

CMD ["npm", "start"]
```

---

## 3. Dockerfile for Frontend
**File: `frontend2/Dockerfile`**
```dockerfile
# Use nginx as base image
FROM nginx:alpine

# Copy HTML file to nginx html directory
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
```

---

## 4. Docker Compose for Local Development
**File: `docker-compose.yml`**
```yaml
version: '3.8'

services:
  # Spring Boot Java Backend
  java-backend:
    build:
      context: ./backend2
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    networks:
      - app-network
    environment:
      - SPRING_PROFILES_ACTIVE=docker

  # Node.js Express Backend
  nodejs-backend:
    build:
      context: ./backend2
      dockerfile: Dockerfile.nodejs
    ports:
      - "5000:5000"
    networks:
      - app-network
    environment:
      - NODE_ENV=production

  # Frontend (Nginx)
  frontend:
    build:
      context: ./frontend2
      dockerfile: Dockerfile
    ports:
      - "80:80"
    networks:
      - app-network
    depends_on:
      - java-backend
      - nodejs-backend

networks:
  app-network:
    driver: bridge
```

---

## 5. Docker Compose for Production (Docker Hub)
**File: `docker-compose.prod.yml`**
```yaml
version: '3.8'

services:
  # Spring Boot Java Backend
  java-backend:
    image: your-dockerhub-username/ncc2025-java-backend:latest
    ports:
      - "8080:8080"
    networks:
      - app-network
    environment:
      - SPRING_PROFILES_ACTIVE=docker

  # Node.js Express Backend
  nodejs-backend:
    image: your-dockerhub-username/ncc2025-nodejs-backend:latest
    ports:
      - "5000:5000"
    networks:
      - app-network
    environment:
      - NODE_ENV=production

  # Frontend (Nginx)
  frontend:
    image: your-dockerhub-username/ncc2025-frontend:latest
    ports:
      - "80:80"
    networks:
      - app-network
    depends_on:
      - java-backend
      - nodejs-backend

networks:
  app-network:
    driver: bridge
```

---

## 6. Docker Hub Push Script
**File: `push-to-dockerhub.sh`**
```bash
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
```

---

## 7. Usage Instructions

### Local Development
```bash
# Build and run all services locally
docker-compose up --build

# Run in detached mode
docker-compose up -d --build

# Stop all services
docker-compose down

# View logs
docker-compose logs
```

### Docker Hub Deployment

1. **Login to Docker Hub:**
   ```bash
   docker login
   ```

2. **Update username in push script:**
   - Edit `push-to-dockerhub.sh`
   - Replace `your-dockerhub-username` with your actual Docker Hub username

3. **Make script executable and run:**
   ```bash
   chmod +x push-to-dockerhub.sh
   ./push-to-dockerhub.sh
   ```

4. **Deploy from Docker Hub:**
   ```bash
   # Update docker-compose.prod.yml with your username first
   docker-compose -f docker-compose.prod.yml up -d
   ```

### Manual Docker Commands

**Build images:**
```bash
# Java Backend
docker build -t ncc2025-java-backend -f backend2/Dockerfile backend2/

# Node.js Backend
docker build -t ncc2025-nodejs-backend -f backend2/Dockerfile.nodejs backend2/

# Frontend
docker build -t ncc2025-frontend -f frontend2/Dockerfile frontend2/
```

**Run individual containers:**
```bash
# Java Backend
docker run -p 8080:8080 ncc2025-java-backend

# Node.js Backend
docker run -p 5000:5000 ncc2025-nodejs-backend

# Frontend
docker run -p 80:80 ncc2025-frontend
```

---

## 8. Service URLs

- **Frontend**: http://localhost:80
- **Java Backend API**: http://localhost:8080/api/hello
- **Node.js Backend API**: http://localhost:5000/api/hello

---

## 9. Docker Hub Images

After pushing, your images will be available at:
- `https://hub.docker.com/r/your-username/ncc2025-java-backend`
- `https://hub.docker.com/r/your-username/ncc2025-nodejs-backend`
- `https://hub.docker.com/r/your-username/ncc2025-frontend`

---

## 10. Quick Start Commands

```bash
# 1. Clone and navigate to project
cd NCC_2025

# 2. For local development
docker-compose up --build

# 3. For Docker Hub deployment
docker login
# Edit push-to-dockerhub.sh with your username
chmod +x push-to-dockerhub.sh
./push-to-dockerhub.sh
# Edit docker-compose.prod.yml with your username
docker-compose -f docker-compose.prod.yml up -d
```

This single file contains everything you need for Docker setup, development, and deployment!
