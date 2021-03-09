{
  description = "Mozilla Hubs Cloud";

  # inputs.nixpkgs.url = "github:happysalada/nixpkgs/fix_build_mix";
  inputs.nixpkgs.url = "github:mkg20001/nixpkgs/fix_mix";
  inputs.nix-node-fod.url = "github:mkg20001/nix-node-fod/master";

  outputs = { self, nixpkgs, nix-node-fod }:

    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in

    {
      overlay = import ./overlay.nix nix-node-fod;

      defaultPackage = forAllSystems (system: (import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      }).janus); #recticulum);

      nixosModules.hubs = import ./modules/hubs.nix;
      nixosModules.janus = import ./modules/janus.nix;

    };
}
