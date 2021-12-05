{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hubs.dialog;
  dialog = pkgs.hubs.dialog;
in
{
  options = {
    services.hubs.dialog = {
      enable = mkEnableOption "Hubs Dialog Server";

      config = mkOption {
        description = "Hubs Dialog options";
        type = types.attrsOf (types.attrs);
      };
    };
  };

  config = mkIf (cfg.enable) {
    users.users.dialog = {
      isSystemUser = true;
      group = "hubs";
    };

    services.hubs.dialog.config = {
      # TODO: stuff
    };

    systemd.services.hubs-dialog = with pkgs; {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network-online.target" ];

      description = "Hubs Dialog Server";

      serviceConfig = {
        Type = "simple";
        User = "dialog";
        Restart = "on-abnormal";
        ExecStart = "${dialog}/bin/dialog";
        LimitNOFILE = 65536;
      };

      environment = {
        # HTTPS_CERT_FULLCHAIN
        # HTTPS_CERT_PRIVKEY
        # AUTH_KEY
      } // cfg.config;
    };
  };
}
