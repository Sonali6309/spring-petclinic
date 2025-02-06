# Stage 1: Build the application
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the entire project into the container
COPY . .

# Build the application using the Maven Wrapper (skip tests for faster builds)
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime environment
FROM openjdk:17-jdk-slim

# Set the working directory inside the runtime container
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar /app/petclinic.jar

# Expose the default Spring Boot port
EXPOSE 8080

# Command to run the Spring Boot application
CMD ["java", "-jar", "/app/petclinic.jar"]
