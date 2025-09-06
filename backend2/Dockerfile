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
