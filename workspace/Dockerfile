# workspace/Dockerfile
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    nginx \
    software-properties-common \
    build-essential \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install PHP and extensions
RUN add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
        php8.2-fpm \
        php8.2-cli \
        php8.2-common \
        php8.2-mysql \
        php8.2-pgsql \
        php8.2-curl \
        php8.2-gd \
        php8.2-mbstring \
        php8.2-xml \
        php8.2-zip \
    && rm -rf /var/lib/apt/lists/*

# Install Python
RUN apt-get update \
    && apt-get install -y python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Java
RUN apt-get update \
    && apt-get install -y openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Go
RUN wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz \
    && rm go1.21.5.linux-amd64.tar.gz

# Install Flutter
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz \
    && tar xf flutter_linux_3.16.0-stable.tar.xz -C /opt \
    && rm flutter_linux_3.16.0-stable.tar.xz

# Add to PATH
ENV PATH="/usr/local/go/bin:/opt/flutter/bin:${PATH}"

# Create necessary directories
RUN mkdir -p /workspace_data \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /var/run/php

# Copy configuration files
COPY config/nginx/* /etc/nginx/sites-available/
RUN ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default

COPY config/php/php.ini /etc/php/8.2/fpm/conf.d/custom.ini
COPY config/supervisor/conf.d/* /etc/supervisor/conf.d/

# Copy scripts
COPY scripts/deploy.sh /app/deploy.sh
COPY scripts/run-app.sh /workspace/scripts/run-app.sh

# Set permissions
RUN chmod +x /app/deploy.sh /workspace/scripts/run-app.sh \
    && chown -R www-data:www-data /workspace_data \
    && chown -R www-data:www-data /var/log/supervisor

# Set working directory
WORKDIR /app

# Start supervisor to manage processes
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]