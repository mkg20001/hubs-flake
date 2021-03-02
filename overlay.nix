nix-node-fod: final: prev: {
  mkNodeFod = nix-node-fod.lib.nix-node-fod prev;
  hubsSrc = prev.callPackage ./src.nix { };
  hubs = prev.callPackage ./hubs.nix { };
  spoke = prev.callPackage ./spoke.nix { };
  janus = prev.callPackage ./janus.nix { };
  reticulum = prev.callPackage ./reticulum.nix { };
}
