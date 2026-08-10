{
  description = "Shared dev workspace for ~/ai";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pi.url = "github:pusherofbrooms/pi-mono-nix";
    codesieve.url = "github:pusherofbrooms/codesieve";

    pi.inputs.nixpkgs.follows = "nixpkgs";
    codesieve.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, pi, codesieve, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f system (import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          })
        );
    in {
      devShells = forAllSystems (system: pkgs: {
        default = pkgs.mkShell {
          packages = [
            pi.packages.${system}.pi
            codesieve.packages.${system}.codesieve
            pkgs.nodejs
            pkgs.agent-browser

            # Keep the workspace consistent with the GNU userland on NixOS.
            pkgs.bashInteractive
            pkgs.coreutils
            pkgs.findutils
            pkgs.gnused
            pkgs.gnugrep
            pkgs.gawk
            pkgs.diffutils
            pkgs.gnutar
          ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            pkgs.google-chrome
          ];

          shellHook = ''
            echo "Loaded ~/ai dev workspace"
            echo "Tools: pi, codesieve, node"
          '';
        };
      });
    };
}
