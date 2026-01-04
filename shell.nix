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
    if [ -d .venv ]; then
      echo "Existing .venv being used"
      source .venv/bin/activate
    else
      echo "Creating .venv..."
      virtualenv .venv
      echo "Installing verisnip via pip..."
      source .venv/bin/activate
      pip install verisnip
    fi
    echo "Shell environment ready!"
  '';
}