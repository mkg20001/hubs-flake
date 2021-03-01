nix-node-package: final: prev: {
  mkNode = nix-node-package.lib.nix-node-package prev;
  hubsSrc = prev.callPackage ./src.nix { };
  hubs = prev.callPackage ./hubs.nix { };
  hubs-admin = prev.callPackage ./hubs-admin.nix { };
  reticulum = prev.callPackage ./reticulum.nix { };
}
