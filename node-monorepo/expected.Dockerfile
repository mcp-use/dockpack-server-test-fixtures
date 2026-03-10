# syntax=docker/dockerfile:1.7

# Node.js workspace/monorepo application
FROM mirror.gcr.io/library/node:22-alpine AS build
WORKDIR /app

# Copy all files (workspaces need full project structure)
COPY . .

# Install dependencies
RUN npm install

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
CMD ["/bin/sh", "-c", "node packages/server/dist/index.js"]
