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
    # FPGA debuger
    openocd
  ];
}