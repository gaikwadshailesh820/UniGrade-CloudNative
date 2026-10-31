
# Stage 1: Build React application
FROM node:22-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy application source code
COPY . .

# Build production application
RUN npm run build

# Stage 2: Production server
FROM nginx:alpine

# Copy React build output to Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose application port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
