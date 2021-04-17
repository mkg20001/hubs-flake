{
  description = "Mozilla Hubs Cloud";

  # inputs.nixpkgs.url = "github:happysalada/nixpkgs/fix_build_mix";
  # inputs.nixpkgs.url = "github:mkg20001/nixpkgs/r_fix_build_mix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nix-node-fod.url = "github:mkg20001/nix-node-fod/master";

  outputs = { self, nixpkgs, nix-node-fod }:

    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      pkgs = forAllSystems (system: (import nixpkgs {
       inherit system;
       overlays = [ self.overlay ];
      }));
    in

    {
      overlay = import ./overlay.nix nix-node-fod;

      defaultPackage = forAllSystems (system: pkgs.${system}.reticulum);

      legacyPackages = forAllSystems (system: {
        inherit (pkgs.${system}) janus reticulum hubs spoke yt-dl-api-server;
      });

      nixosModules.hubs = import ./modules/hubs.nix;
      nixosModules.janus = import ./modules/janus.nix;
      nixosModules.yt-dl-api-server = import ./modules/yt-dl-api-server.nix;

    };
}
