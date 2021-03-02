{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.janus;
  janus = pkgs.janus;
in
{
  imports = [
    ./janus.nix
  ];

  options = {
    services.janus = {
      enable = mkEnableOption "Janus WebRTC";
    };
  };

  config = mkIf (cfg.enable) {
    users.users.janus = {
      uid = config.ids.uids.janus;
    };

    systemd.services.janus = with pkgs; {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network-online.target" ];

      description = "Janus WebRTC";

      serviceConfig = {
        Type = "simple";
        User = "janus";
        Restart = "on-abnormal";
        ExecStart = "${janus}/bin/janus -o";
        LimitNOFILE = 65536;
      };

      unitConfig = {
        Documentation = "https://janus.conf.meetecho.com/docs/index.html";
      };
    };

    environment.systemPackages = [ janus ];

    ids.gids.janus = 331;
    ids.uids.janus = 331;
  };
}
