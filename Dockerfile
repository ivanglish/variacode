# Use the official Nginx image as the base
FROM nginx:alpine

# Copy the static HTML file into the Nginx default public directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 to the outside world
EXPOSE 80