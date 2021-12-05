{
  description = "Mozilla Hubs Cloud";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nix-node-fod.url = "github:mkg20001/nix-node-fod/master";
  inputs.speelycaptor.url = "github:mkg20001/speelycaptor-hapi/master";
  inputs.speelycaptor.inputs.nixpkgs.follows = "nixpkgs";
  inputs.photomnemonic.url = "github:mkg20001/photomnemonic-hapi/master";
  inputs.photomnemonic.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, nix-node-fod, speelycaptor, photomnemonic }:

    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      pkgs = forAllSystems (system: (import nixpkgs {
        inherit system;
        overlays = self.overlays;
      }));
    in

    {
      overlay = import ./overlay.nix nix-node-fod;

      overlays = [ self.overlay speelycaptor.overlay photomnemonic.overlay ];

      defaultPackage = forAllSystems (system: pkgs.${system}.reticulum);

      legacyPackages = forAllSystems (system: {
        inherit (pkgs.${system}) janus reticulum hubs spoke yt-dl-api-server speelycaptor photomnemonic;
      });

      nixosModules.hubs = import ./modules/hubs.nix;
      nixosModules.janus = import ./modules/janus.nix;
      nixosModules.yt-dl-api-server = import ./modules/yt-dl-api-server.nix;
      nixosModules.speelycaptor = speelycaptor.nixosModules.speelycaptor;
      nixosModules.photomnemonic = photomnemonic.nixosModules.photomnemonic;

      allModules = builtins.attrValues self.nixosModules;

    };
}
