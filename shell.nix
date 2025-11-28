{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  name = "MyShell";
  buildInputs = with pkgs; [
    python3
    picocom
    # Verilog Simulation Tools
    iverilog
    verilator
    # Other Verilog Tools
    gtkwave
    verible
    # sv-lang
    # FPGA tools
    yosys
    nextpnr
    trellis
    icestorm
    openfpgaloader
    # FPGA debugger
    openocd
    # Python packages
    python3Packages.pip
    python3Packages.virtualenv
  ];
  
  shellHook = ''
    echo Entering pure nix-shell...
    export PYTHONPATH=
    export PATH=$PWD/.venv/bin:$PATH
    virtualenv .venv
    source .venv/bin/activate    
    echo "Installing verisnip via pip..."
    pip install verisnip
    echo "Shell environment ready!"
  '';
}