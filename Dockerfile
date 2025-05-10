# Stage 1: Build Stage
FROM python:3.8-alpine AS build

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install build dependencies (required to install Python packages)
RUN apk update && apk add --no-cache \
    build-base \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python3-dev \
    bash

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final Stage (Slim runtime)
FROM python:3.8-alpine

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install runtime dependencies
RUN apk update && apk add --no-cache \
    libffi-dev \
    openssl-dev \
    bash

# Install gunicorn in the final runtime image
RUN pip install gunicorn

# Copy installed dependencies from the build stage
COPY --from=build /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages

# Copy the rest of the app
COPY . .

# Expose the app port
EXPOSE 8787

# Start the app with gunicorn binding to 0.0.0.0
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:${PORT:-8787} wsgi:app"]
