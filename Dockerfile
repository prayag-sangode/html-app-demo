# Use an official Nginx base image from Docker Hub
FROM nginx:latest
# Set metadata for the image (optional)
LABEL maintainer="prayag.rhce@gmail.com"
LABEL description="Nginx Web Server Docker Image"
# Copy the contents of the "website" folder into the web root directory
COPY website /usr/share/nginx/html
# Expose port 80 for incoming HTTP traffic
EXPOSE 80
# Define the command to start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
