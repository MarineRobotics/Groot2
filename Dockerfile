FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base tools (rarely changes)
RUN apt-get update && apt-get install -y \
    curl \
    fuse \
    libfuse2 \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ARG GROOT_VERSION=1.7.1
ARG GROOT_ARCH=aarch64

# Download and extract AppImage (cached unless version changes)
WORKDIR /opt
RUN curl -L -o Groot2.AppImage \
    "https://pub-32cef6782a9e411e82222dee82af193e.r2.dev/Groot2-v${GROOT_VERSION}-${GROOT_ARCH}.AppImage" \
    && chmod +x Groot2.AppImage \
    && ./Groot2.AppImage --appimage-extract \
    && mv squashfs-root groot2 \
    && rm Groot2.AppImage

# Install Qt6 and GUI runtime dependencies
RUN apt-get update && apt-get install -y \
    qt6-base-dev \
    libgl1 \
    libopengl0 \
    libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

# Create a simple launcher script
RUN echo '#!/bin/bash\n/opt/groot2/AppRun "$@"' > /usr/local/bin/groot2 \
    && chmod +x /usr/local/bin/groot2

WORKDIR /root

CMD ["/opt/groot2/AppRun"]
