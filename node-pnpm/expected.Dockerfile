# Optimized Dockerfile for Node.js applications
FROM mirror.gcr.io/library/node:22-alpine AS dependencies
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@latest --activate
# Copy package files
COPY package*.json ./


# Install dependencies
RUN pnpm install

# Build stage
FROM mirror.gcr.io/library/node:22-alpine AS build
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@latest --activate
# Copy dependencies
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

# Build application
RUN pnpm build

# Runtime stage
FROM mirror.gcr.io/library/node:22-alpine
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@latest --activate
# Copy built application
COPY --from=build /app .

# Expose port
EXPOSE 3000

# Start the application
CMD ["/bin/sh", "-c", "pnpm start"]
