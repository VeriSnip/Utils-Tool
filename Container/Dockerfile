FROM ubuntu:24.04

# Install base dependencies
RUN apt-get update && apt-get install -y \
    git help2man perl python3 make autoconf g++ flex bison ccache libgoogle-perftools-dev numactl perl-doc libfl2 libfl-dev \
    build-essential clang lld libreadline-dev gawk tcl-dev libffi-dev graphviz xdot pkg-config libboost-system-dev libboost-python-dev libboost-filesystem-dev zlib1g-dev \
    mercurial libftdi-dev python3-dev libboost-all-dev cmake libeigen3-dev \
    openfpgaloader \
    python3-pip \
    picocom \
    iverilog \
    gtkwave \
    openocd \
    libusb-1.0-0-dev \
    udev \
    automake \
    gperf \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Verilator (latest stable)
RUN git clone https://github.com/verilator/verilator && \
    cd verilator && \
    git pull && \
    git checkout v5.032 && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf verilator

# Install Verible (latest release)
RUN VERIBLE_VERSION=v0.0-3933-g0e3fe53a && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
    VERIBLE_ARCH="x86_64"; \
    else \
    VERIBLE_ARCH="arm64"; \
    fi && \
    wget https://github.com/chipsalliance/verible/releases/download/$VERIBLE_VERSION/verible-$VERIBLE_VERSION-linux-static-$VERIBLE_ARCH.tar.gz && \
    tar -xzvf verible-*.tar.gz && \
    cp verible-*/bin/* /usr/local/bin/ && \
    rm -rf verible-*

# Install Yosys
RUN git clone --recurse-submodules https://github.com/YosysHQ/yosys.git && \
    cd yosys && \
    make && \
    make install && \
    cd .. && \
    rm -rf yosys

# Install Project Trellis
RUN git clone https://github.com/YosysHQ/prjtrellis && \
    cd prjtrellis/libtrellis && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local . && \
    make && \
    make install && \
    cd .. && \
    rm -rf prjtrellis

# Install Project IceStorm
RUN git clone https://github.com/YosysHQ/icestorm.git && \
    cd icestorm && \
    make && \
    make install && \
    cd .. && \
    rm -rf icestorm

# Install nextpnr
RUN git clone https://github.com/YosysHQ/nextpnr && \
    cd nextpnr && \
    cmake -DARCH="ecp5;ice40" \
          -DTRELLIS_ROOT=/usr/local/share/trellis \
          -DICE40_ROOT=/usr/local/share/icebox \
          -DCMAKE_INSTALL_PREFIX=/usr/local . && \
    make && \
    make install && \
    cd .. && \
    rm -rf nextpnr

# Verify installations
RUN which verilator && \
    which verible-verilog-ls && \
    which yosys && \
    which nextpnr-ecp5 && \
    which nextpnr-ice40 && \
    which openFPGALoader

# Configure USB access
COPY 99-fpga.rules /etc/udev/rules.d/99-fpga.rules
RUN udevadm control --reload-rules && \
    udevadm trigger

# Set environment variables
ENV SandBox=/SandBox
ENV XILINX_PATH=/opt/Xilinx
ENV ALTERA_PATH=/opt/Altera
WORKDIR /SandBox
