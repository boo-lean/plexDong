# Use a slim Alpine-based Python image
FROM python:3.8-alpine

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8787  # fallback default if $PORT isn't set in the environment

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apk update && apk add --no-cache \
    build-base \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python3-dev \
    postgresql-dev \
    linux-headers \
    bash

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the app
COPY . .

# Expose the app port
EXPOSE $PORT

# Start the app with gunicorn binding to 0.0.0.0 and the env port
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT wsgi:app"]
