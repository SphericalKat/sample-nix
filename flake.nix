{
  description = "A simple C program";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in rec {
        sample-nix = pkgs.stdenv.mkDerivation {
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

        packages.default = sample-nix;

        packages.docker = pkgs.dockerTools.buildLayeredImage {
          name = "ghcr.io/sphericalkat/sample-nix";
          tag = "latest";
          config.Cmd = [ "${sample-nix}/bin/sample-nix" ];
        };
      }
    );
}