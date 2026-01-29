# ================================
# Stage 1: Production Build
# ================================
FROM node:20-alpine AS production

# Set working directory
WORKDIR /app

# Install production dependencies only
COPY package.json package-lock.json ./
RUN npm ci --only=production

# Copy application code
COPY . .

# Create uploads directory for file storage
RUN mkdir -p uploads/restricted

# Expose the API port
EXPOSE 5000

# Set environment to production
ENV NODE_ENV=production

# Start the server
CMD ["node", "server.js"]
