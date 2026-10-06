{
  description = "Shared dev workspace for ~/ai";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pi.url = "github:earendil-works/pi/stable";

    pi.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, pi, ... }:
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
      devShells = forAllSystems (system: pkgs:
        let
          # On macOS, upstream's unit tests discover Chrome in /Applications
          # and repeatedly launch it. Linux builds do not see a system browser.
          # Keep checks enabled everywhere else while nixpkgs/upstream fixes it.
          agentBrowser = pkgs.agent-browser.overrideAttrs (_:
            pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
              doCheck = false;
            }
          );
        in {
          default = pkgs.mkShell {
            packages = [
              pi.packages.${system}.pi
              pkgs.nodejs
              agentBrowser

              # Keep the workspace consistent with the GNU userland on NixOS.
              pkgs.bashInteractive
              pkgs.coreutils
              pkgs.findutils
              pkgs.gnused
              pkgs.gnugrep
              pkgs.gawk
              pkgs.diffutils
              pkgs.gnutar
            ] ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
              pkgs.google-chrome
            ];

            shellHook = ''
              echo "Loaded ~/ai dev workspace"
              echo "Tools: pi, node, gnu core utils, agentBrowser"
            '';
          };
        });
    };
}
