{
  description = "A simple C program";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "sample-nix";
        src = ./.;

        buildInputs = with pkgs; [
          gcc
        ];

        buildPhase = ''
          gcc -o sample-nix main.c
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp sample-nix $out/bin/
        '';
      };
    };
}