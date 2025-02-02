{
  description = "zig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    zig,
  }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = import nixpkgs {
      inherit system;
      overlays = [zig.overlays.default];
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        zigpkgs.default
        zls
      ];
    };
  };
}
