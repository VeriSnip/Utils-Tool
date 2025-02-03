#!/usr/bin/env bash

# Configuration
CONTAINER_NAME="fpga-dev-container"
IMAGE_NAME="fpga-dev"
SANDBOX_DIR="$(pwd)"
XILINX_PATH="${XILINX_PATH:-/dev/null}"
ALTERA_PATH="${ALTERA_PATH:-/dev/null}"
DOCKERFILE_PATH="$(dirname "$0")/Dockerfile"

# Check if --clean argument was passed and remove images and containers
if [[ "$1" == "--clean" ]]; then
    echo "Cleaning up images and containers..."
    podman rm -f "$CONTAINER_NAME"
    podman rmi -f "$IMAGE_NAME"
    exit 0
fi

# Check if --build argument was passed and execute build if so. Otherwise pull image from Docker Hub
if [[ "$1" == "--build" ]]; then
    echo "Building image..."
    podman manifest create "$IMAGE_NAME"
    podman build --platform linux/amd64,linux/arm64 --manifest "localhost/$IMAGE_NAME" -f "$DOCKERFILE_PATH" .
    #podman manifest push "localhost/$IMAGE_NAME":latest docker://docker.io/pedroantunes178/$IMAGE_NAME:latest
else
    echo "Pulling image from Docker Hub..."
    podman pull docker.io/library/"$IMAGE_NAME"
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