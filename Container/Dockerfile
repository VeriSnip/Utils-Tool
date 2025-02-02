FROM ubuntu:24.04

# Install base dependencies
RUN apt-get update && apt-get install -y \
    git help2man perl python3 make autoconf g++ flex bison ccache \
    libgoogle-perftools-dev numactl perl-doc \
    libfl2 \
    libfl-dev \
    zlibc zlib1g zlib1g-dev \
    python3-pip \
    picocom \
    iverilog \
    gtkwave \
    openocd \
    libusb-1.0-0-dev \
    udev \
    build-essential \
    cmake \
    automake \
    libfl2 \
    libfl-dev \
    gperf \
    tcl-dev \
    libboost-all-dev \
    libeigen3-dev \
    libftdi-dev \
    libreadline-dev \
    pkg-config \
    zlib1g-dev \
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
RUN VERIBLE_VERSION=0.0-3423-gf1aafd79 && \
    wget https://github.com/chipsalliance/verible/releases/download/$VERIBLE_VERSION/verible-$VERIBLE_VERSION-Ubuntu-22.04-jammy-x86_64.tar.gz && \
    tar -xzvf verible-*.tar.gz && \
    cp verible-*/bin/* /usr/local/bin/ && \
    cp -R verible-*/share/verible /usr/local/share/ && \
    rm -rf verible-*

# Install Yosys
RUN git clone https://github.com/YosysHQ/yosys.git && \
    cd yosys && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf yosys

# Install Project Trellis
RUN git clone https://github.com/YosysHQ/prjtrellis && \
    cd prjtrellis && \
    cmake . && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf prjtrellis

# Install IceStorm
RUN git clone https://github.com/YosysHQ/icestorm.git && \
    cd icestorm && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf icestorm

# Install nextpnr
RUN git clone https://github.com/YosysHQ/nextpnr && \
    cd nextpnr && \
    cmake . -DARCH="ecp5;ice40" \
            -DTRELLIS_ROOT=/usr/local/share/trellis \
            -DICE40_ROOT=/usr/local/share/icebox && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf nextpnr

# Install openFPGALoader
RUN git clone https://github.com/trabucayre/openFPGALoader.git && \
    cd openFPGALoader && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    cd ../../ && \
    rm -rf openFPGALoader

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
