# Groot2 Docker Image

Docker container for [Groot2](https://www.behaviortree.dev/groot/), the graphical editor for BehaviorTree.CPP.

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

## Automated Builds

A GitHub Actions workflow checks daily for new Groot2 versions by scraping the [BehaviorTree/Groot2](https://github.com/BehaviorTree/Groot2) changelog. When a new version is detected, it automatically builds and pushes to Docker Hub.

It can also be triggered manually from the Actions tab with a specific version number.

### Setup

A Docker Hub access token is required as a repository secret:
1. Create an access token at https://hub.docker.com/settings/security
2. Go to repo Settings > Secrets and variables > Actions
3. Add a secret named `DOCKERHUB_TOKEN`
