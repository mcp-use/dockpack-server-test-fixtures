
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

# Generate mcp-use tool registry types
RUN if [ -f package.json ] && grep -q '"mcp-use"' package.json; then \
      server_file=""; \
      for f in index.ts src/index.ts server.ts src/server.ts; do \
        if [ -f "$f" ]; then server_file="$f"; break; fi; \
      done; \
      if [ -n "$server_file" ]; then \
        npx mcp-use generate-types --server "$server_file"; \
      else \
        echo "No server file found - skipping mcp-use generate-types"; \
      fi; \
    fi

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
