nix-node-fod: final: prev: {
  mkNodeFod = nix-node-fod.lib.nix-node-fod prev;
  hubsSrc = prev.callPackage ./src.nix { };
  hubs = prev.callPackage ./pkgs/hubs.nix { };
  spoke = prev.callPackage ./pkgs/spoke.nix { };
  janus = prev.callPackage ./pkgs/janus.nix { };
  reticulum = prev.callPackage ./pkgs/reticulum.nix { };
  yt-dl-api-server = prev.callPackage ./pkgs/yt-dl-api-server.nix { };
}
