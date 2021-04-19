{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.yt-dl-api-server;
  yt-dl-api-server = pkgs.yt-dl-api-server;
in
{
  options = {
    services.yt-dl-api-server = {
      enable = mkEnableOption "youtube-dl-api-server";

      port = mkOption {
        description = "Port to listen at";
        type = types.int;
        default = 9191;
      };

      numberProcesses = mkOption {
        description = "Number of maximum download processes";
        type = types.int;
        default = 5;
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for youtube-dl-api-server.";
      };
    };
  };

  config = mkIf (cfg.enable) {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.yt-dl-api-server = with pkgs; {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network-online.target" ];

      description = "youtube-dl-api-server";

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        ExecStart = "${yt-dl-api-server}/bin/youtube-dl-api-server --host :: --port ${toString cfg.port} --number-processes ${toString cfg.numberProcesses}";
      };
    };
  };
}
