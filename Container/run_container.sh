#!/usr/bin/env bash

# Color codes
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
CONTAINER_NAME="fpga-dev-container"
IMAGE_NAME="fpga-dev"
SANDBOX_DIR="$(pwd)"
DOCKERFILE_PATH="$(dirname "$0")/Dockerfile"

# Initialize variables
DEVICE_ARGS=()
VOLUME_ARGS=()
BUILD_FLAG=false
CLEAN_FLAG=false
FORCE_RECREATE=false

# Check and display vendor path status
check_vendor_path() {
    local vendor_name=$1
    local env_var=$2
    local path="${!env_var}"
    
    if [[ -n "$path" && -d "$path" ]]; then
        echo -e "${GREEN}✓ $vendor_name path configured: $path${NC}"
        return 0
    else
        echo -e "${ORANGE}⚠  $vendor_name path not configured or invalid!"
        echo -e "   Set the $env_var environment variable to enable ${vendor_name} toolchain mounting${NC}"
        return 1
    fi
}

get_existing_mount() {
    podman inspect "$CONTAINER_NAME" --format "{{range .Mounts}}{{if eq .Destination \"$1\"}}{{.Source}}{{end}}{{end}}" 2>/dev/null
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --device)
            DEVICE_ARGS+=("--device" "$2")
            shift 2
            ;;
        --build)
            CLEAN_FLAG=true
            BUILD_FLAG=true
            shift
            ;;
        --clean)
            CLEAN_FLAG=true
            shift
            ;;
        --force)
            FORCE_RECREATE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Handle clean flag
if [[ "$CLEAN_FLAG" == true ]]; then
    echo "Cleaning up images and containers..."
    podman rm -f "$CONTAINER_NAME"
    podman rmi -f "$IMAGE_NAME"
    exit 0
fi

# Handle build/pull logic
if [[ "$BUILD_FLAG" == true ]]; then
    echo "Building image..."
    podman manifest create "$IMAGE_NAME"
    podman build --platform linux/amd64,linux/arm64 --manifest "localhost/$IMAGE_NAME" -f "$DOCKERFILE_PATH" .
else
    if ! podman image exists "$IMAGE_NAME"; then
        echo "Image does not exist locally. Pulling image from Docker Hub..."
        podman pull docker.io/library/"$IMAGE_NAME" || {
            echo "Failed to pull image. Use --build to build locally."
            exit 1
        }
    fi
fi

echo -e "\n=== Toolchain Configuration ==="
check_vendor_path "AMD/Xilinx" "XILINX_PATH"
check_vendor_path "Altera/Intel" "ALTERA_PATH"
echo -e "==============================\n"
# Configure conditional volumes
if [[ -n "$XILINX_PATH" && -d "$XILINX_PATH" ]]; then
    VOLUME_ARGS+=(-v "$XILINX_PATH:/opt/Xilinx:Z")
fi
if [[ -n "$ALTERA_PATH" && -d "$ALTERA_PATH" ]]; then
    VOLUME_ARGS+=(-v "$ALTERA_PATH:/opt/Altera:Z")
fi

if podman container exists "$CONTAINER_NAME"; then
    # Get existing configuration
    OLD_SANDBOX=$(get_existing_mount "/SandBox")
    OLD_XILINX=$(get_existing_mount "/opt/Xilinx")
    OLD_ALTERA=$(get_existing_mount "/opt/Altera")

    # Check for changes
    # Check for changes
    CHANGES=()
    [[ "$OLD_SANDBOX" != "$SANDBOX_DIR" ]] && CHANGES+=("SANDBOX_DIR: $OLD_SANDBOX → $SANDBOX_DIR")
    [[ "$XILINX_PATH" != "$OLD_XILINX" ]] && CHANGES+=("XILINX_PATH: ${OLD_XILINX:-<none>} → ${XILINX_PATH:-<none>}")
    [[ "$ALTERA_PATH" != "$OLD_ALTERA" ]] && CHANGES+=("ALTERA_PATH: ${OLD_ALTERA:-<none>} → ${ALTERA_PATH:-<none>}")

    # Handle detected changes
    if [[ ${#CHANGES[@]} > 0 ]]; then
        echo -e "\n${ORANGE}Configuration changes detected:${NC}"
        for change in "${CHANGES[@]}"; do
            echo -e "  ${ORANGE}• $change${NC}"
        done
        if [[ "$FORCE_RECREATE" == true ]]; then
            echo "Forcing container recreation..."
            podman rm -f "$CONTAINER_NAME"
        else
            read -p "Apply changes by recreating container? [y/N] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                podman rm -f "$CONTAINER_NAME"
            else
                echo "Using existing configuration."
            fi
        fi
    fi
fi

if ! podman container exists "$CONTAINER_NAME"; then
    echo -e "${CYAN}Creating new container...${NC}"
    podman run -it --name "$CONTAINER_NAME" \
        -v "$SANDBOX_DIR:/SandBox:Z" \
        "${VOLUME_ARGS[@]}" \
        "${DEVICE_ARGS[@]}" \
        --security-opt label=disable \
        "$IMAGE_NAME"
else
    echo -e "${CYAN}Starting existing container...${NC}"
    if [[ "$(podman inspect -f '{{.State.Status}}' "$CONTAINER_NAME")" == "running" ]]; then
        echo "Container is already running. Attaching..."
        podman attach "$CONTAINER_NAME"
    else
        podman start -ia "$CONTAINER_NAME"
    fi
fi

#ls -lha /dev/tty* | grep usb
#        --device /dev/tty.usb* \
#        -e DISPLAY="$DISPLAY" \
#        -v /tmp/.X11-unix:/tmp/.X11-unix:Z \
# Container management