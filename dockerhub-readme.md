# Groot2 Docker Image

Docker container for [Groot2](https://www.behaviortree.dev/groot/), the graphical editor for BehaviorTree.CPP.

## Quick Start

```bash
docker pull mrobotics/groot2:latest
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
     mrobotics/groot2:latest
   ```

### Linux

```bash
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -p 1667:1667 \
  mrobotics/groot2:latest
```

## Mounting Host Files

To access files from your host machine (e.g. behavior tree XML files), add a volume mount:

```bash
docker run -it --rm \
  -e DISPLAY=host.docker.internal:0 \
  -p 1667:1667 \
  -v ~/path/to/your/projects:/root/projects \
  mrobotics/groot2:latest
```

## Docker Compose

```yaml
services:
  groot2:
    image: mrobotics/groot2:latest
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

## Notes

- This image is built for **aarch64** (ARM64) architecture
- Based on Ubuntu 24.04
- Network mode `host` does not work on macOS; use port mapping instead
- New versions are automatically built and pushed when detected
