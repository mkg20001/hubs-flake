nix-node-fod: final: prev: {
  mkNodeFod = nix-node-fod.lib.nix-node-fod prev;
  hubsSrc = prev.callPackage ./src.nix { };
  hubs = prev.callPackage ./hubs.nix { };
  hubs-admin = prev.callPackage ./hubs-admin.nix { };
  reticulum = prev.callPackage ./reticulum.nix { };
}
