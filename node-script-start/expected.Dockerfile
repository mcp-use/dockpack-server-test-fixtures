# syntax=docker/dockerfile:1.7

# Optimized Dockerfile for Node.js applications
FROM mirror.gcr.io/library/node:22-alpine AS dependencies
WORKDIR /app
# Copy package files
COPY package*.json ./


# Install dependencies
RUN npm install

# Build stage
FROM mirror.gcr.io/library/node:22-alpine AS build
WORKDIR /app
# Copy dependencies
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

# Build application
RUN npm run build

# Runtime stage
FROM mirror.gcr.io/library/node:22-alpine
WORKDIR /app
# Copy built application
COPY --from=build /app .

# Expose port
EXPOSE 3000

# Start the application
CMD ["/bin/sh", "-c", "npm start"]
