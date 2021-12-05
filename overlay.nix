nix-node-fod: nix-node-package: final: prev: {
  hubs = prev.lib.makeScope prev.newScope (self: with self; {
    mkNodeFod = nix-node-fod.lib.nix-node-fod prev;
    mkNode = nix-node-package.lib.nix-node-package prev;
    dialog = callPackage ./dialog.nix { };
    hubsSrc = callPackage ./src.nix { };
    hubs = callPackage ./pkgs/hubs.nix { };
    spoke = callPackage ./pkgs/spoke.nix { };
    janus = callPackage ./pkgs/janus.nix { };
    reticulum = callPackage ./pkgs/reticulum.nix { };
    yt-dl-api-server = callPackage ./pkgs/yt-dl-api-server.nix { };
  });
}
