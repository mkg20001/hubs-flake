{
  description = "Mozilla Hubs Cloud";

  # inputs.nixpkgs.url = "github:happysalada/nixpkgs/fix_build_mix";
  inputs.nixpkgs.url = "github:mkg20001/nixpkgs/fix_build_mix";
  inputs.nix-node-package.url = "github:mkg20001/nix-node-package/master";

  outputs = { self, nixpkgs, nix-node-package }:

    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in

    {
      overlay = import ./overlay.nix nix-node-package;

      defaultPackage = forAllSystems (system: (import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      }).recticulum);

      nixosModules.hubs = import ./module.nix;

    };
}
