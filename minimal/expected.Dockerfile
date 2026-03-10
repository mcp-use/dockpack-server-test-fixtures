
# Minimal Node.js application (no package.json)
FROM mirror.gcr.io/library/node:22-alpine
WORKDIR /app

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Start the application
CMD ["/bin/sh", "-c", "node index.js"]
