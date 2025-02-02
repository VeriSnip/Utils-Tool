#!/usr/bin/env bash

# Configuration
CONTAINER_NAME="fpga-dev-container"
IMAGE_NAME="fpga-dev"
SANDBOX_DIR="$(pwd)"
XILINX_PATH="${XILINX_PATH:-/dev/null}"
ALTERA_PATH="${ALTERA_PATH:-/dev/null}"
DOCKERFILE_PATH="$(dirname "$0")/Dockerfile"

# Build image if missing
if ! podman image exists "$IMAGE_NAME"; then
    echo "Building image..."
    podman build -t "$IMAGE_NAME" -f "$DOCKERFILE_PATH" .
fi

# Container management
if ! podman container exists "$CONTAINER_NAME"; then
    echo "Creating new container..."
    podman run -it --name "$CONTAINER_NAME" \
        --device /dev/bus/usb \
        -v "$SANDBOX_DIR:/SandBox:Z" \
        -v "$XILINX_PATH:/opt/Xilinx:Z" \
        -v "$ALTERA_PATH:/opt/Altera:Z" \
        -e DISPLAY="$DISPLAY" \
        -v /tmp/.X11-unix:/tmp/.X11-unix:Z \
        --security-opt label=disable \
        --replace \
        "$IMAGE_NAME"
else
    echo "Starting existing container..."
    if [ "$(podman inspect -f '{{.State.Status}}' "$CONTAINER_NAME")" == "running" ]; then
        echo "Container is already running. Attaching..."
        podman attach "$CONTAINER_NAME"
    else
        podman start -ia "$CONTAINER_NAME"
    fi
fi