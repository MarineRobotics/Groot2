# Groot2 Docker Image

Docker container for [Groot2](https://www.behaviortree.dev/groot/), the graphical editor for BehaviorTree.CPP.

**Docker Hub:** https://hub.docker.com/repository/docker/mrobotics/groot2/general

## Overview

We containerized Groot2 to make it easier to run on macOS without dealing with native dependencies. The setup uses:

- **Ubuntu 24.04** as the base image
- **Qt6** installed via apt for all the GUI dependencies
- **XQuartz** on macOS to forward the display from the container to the host
- **AppImage extraction** since FUSE (required to run AppImages directly) isn't available inside containers

### Port Configuration

Groot2 communicates with BehaviorTree.CPP applications over ZMQ, typically on port **1667**. The container exposes this port so Groot2 can connect to behavior tree applications running on the host machine.

**Important:** Since Docker on macOS runs containers inside a VM, `--network host` doesn't work. You must use explicit port mapping (`-p 1667:1667`). If your BT application uses a different port, update both the `-p` flag and your Groot2 connection settings accordingly.

To connect from Groot2 inside the container to an app on your Mac, use `host.docker.internal` as the hostname instead of `localhost`.

## Quick Start

```bash
docker pull mrobotics/groot2:v1.7.1
```

### macOS (with XQuartz)

1. Install and start XQuartz:
   ```bash
   brew install --cask xquartz
   ```

2. Allow connections (run after each XQuartz restart):
   ```bash
   xhost +localhost
   ```

3. Run the container:
   ```bash
   docker run -it --rm \
     -e DISPLAY=host.docker.internal:0 \
     -p 1667:1667 \
     mrobotics/groot2:v1.7.1
   ```

### Linux

```bash
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -p 1667:1667 \
  mrobotics/groot2:v1.7.1
```

## Docker Compose

```yaml
services:
  groot2:
    image: mrobotics/groot2:v1.7.1
    environment:
      - DISPLAY=host.docker.internal:0  # macOS
      # - DISPLAY=${DISPLAY}            # Linux
    volumes:
      - groot2-data:/root
    ports:
      - "1667:1667"
    stdin_open: true
    tty: true

volumes:
  groot2-data:
```

## Tags

- `v1.7.1` - Groot2 v1.7.1 (aarch64)
- `latest` - Latest version

## Notes

- This image is built for **aarch64** (ARM64) architecture
- Based on Ubuntu 24.04
- Network mode `host` does not work on macOS; use port mapping instead

---

## Build Details

### How This Was Built

1. Created a Dockerfile that:
   - Uses Ubuntu 24.04 as base
   - Downloads the Groot2 AppImage directly from a URL
   - Extracts the AppImage (since FUSE isn't available in containers)
   - Installs Qt6 and OpenGL dependencies

2. Created a docker-compose.yml for easier local development with:
   - XQuartz display forwarding for macOS
   - Port 1667 exposed for BehaviorTree.CPP ZMQ communication
   - Volume for persisting Groot2 configuration

3. Built and pushed to Docker Hub:
   ```bash
   docker compose build
   docker push mrobotics/groot2:v1.7.1
   docker tag mrobotics/groot2:v1.7.1 mrobotics/groot2:latest
   docker push mrobotics/groot2:latest
   ```

### AppImage Download URL

The Dockerfile uses a **hardcoded URL** for the Groot2 AppImage:

```
https://pub-32cef6782a9e411e82222dee82af193e.r2.dev/Groot2-v1.7.1-aarch64.AppImage
```

**This URL may change or become unavailable in the future.** If updating to a new version:
1. Get the new AppImage URL from the Groot2 releases
2. Update the URL in the Dockerfile
3. Update the version tag in docker-compose.yml
4. Rebuild and push

### Automated Builds (GitHub Actions)

A GitHub Actions workflow (`.github/workflows/build-and-push.yml`) automatically checks for new Groot2 versions daily. It works by:

1. Scraping the changelog from the [BehaviorTree/Groot2](https://github.com/BehaviorTree/Groot2) GitHub README to detect the latest version
2. Checking Docker Hub to see if that version tag already exists
3. If it's a new version, building the image and pushing both `v{version}` and `latest` tags

The workflow can also be triggered manually from the Actions tab with a specific version number.

**Required setup:** A Docker Hub access token must be stored as a GitHub repository secret:
1. Create an access token at https://hub.docker.com/settings/security
2. Go to the repo's Settings > Secrets and variables > Actions
3. Add a secret named `DOCKERHUB_TOKEN` with the token value

The workflow runs on an ARM runner (`ubuntu-24.04-arm`) since the AppImage is aarch64.

### Source Files

The Dockerfile and docker-compose.yml are stored in: `/Users/vince/software/docker/groot2/`
