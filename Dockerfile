# Multi-stage Dockerfile with security best practices
# Stage 1: Build stage
FROM node:18-alpine AS node-builder

# Set working directory
WORKDIR /app

# Install dependencies for security scanning
RUN apk add --no-cache \
    git \
    python3 \
    py3-pip \
    && pip3 install --no-cache-dir \
    bandit \
    safety \
    trufflehog

# Copy package files
COPY package*.json ./
COPY tsconfig.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY src/ ./src/

# Build the application
RUN npm run build

# Stage 2: Python build stage
FROM python:3.11-slim AS python-builder

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy Python source code
COPY . .

# Stage 3: Production stage
FROM python:3.11-slim AS production

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set working directory
WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Copy built applications from previous stages
COPY --from=node-builder /app/dist ./dist
COPY --from=python-builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

# Copy application files
COPY --from=python-builder /app ./

# Create necessary directories
RUN mkdir -p /app/logs /app/data && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Default command
CMD ["python", "-m", "http.server", "8000"]

# Security labels
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Repository template with security best practices"
LABEL version="0.1.0"
LABEL security.scan="true" 