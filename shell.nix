{ pkgs ? import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixos-22.11";
  # Commit hash for nixos-22.11
  url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.11.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";
}) {}}:
pkgs.mkShell {
  name = "MyShell";
  buildInputs = with pkgs; [
    python3
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
  ];
}