{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  name = "MyShell";
  buildInputs = with pkgs; [
    python3
    picocom
    # Verilog Simulation Tools
    verilog
    verilator
    # Other Verilog Tools
    gtkwave
    verible
    # FPGA tools
    yosys
    nextpnr
    trellis
    icestorm
    openfpgaloader
    # FPGA debugger
    openocd
    # Python packages
    (python3.withPackages (ps: with ps; [
      pip
    ]))
  ];
  
  shellHook = ''
    # Create a temporary directory for pip packages
    export PIP_PREFIX=$(mktemp -d)
    export PYTHONPATH="$PIP_PREFIX/lib/python3.12/site-packages:$PYTHONPATH"
    export PATH="$PIP_PREFIX/bin:$PATH"
    
    echo "Installing verisnip via pip..."
    pip install --prefix=$PIP_PREFIX verisnip
    echo "Shell environment ready!"
  '';
}