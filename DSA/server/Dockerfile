# Use the official Ballerina runtime base image for your desired version
FROM ballerina/ballerina:latest

# Set the working directory to /app
WORKDIR /home/ballerina

# Copy the Ballerina source code into the container
COPY performance_management_service.bal .

# Expose the port that your Ballerina service will run on
EXPOSE 8088

# Run your Ballerina service
CMD ["ballerina", "run", "performance_management_service.bal"]