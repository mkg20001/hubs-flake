{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hubs;
  reticulum = pkgs.reticulum;
in
{
  options = {
    services.hubs = {
      enable = mkEnableOption "Mozilla Hubs";
      workingDirectory = mkOption {
        type = types.str;
        default = "/var/reticulum";
      };
    };
  };

  config = mkIf (cfg.enable) {
    services.postgresql = {
      enable = true;
      # TODO: setup reticulum db

      ensureUsers = [{
        name = "hubs";
        ensurePermissions = { "DATABASE ret_prod" = "ALL PRIVILEGES"; };
      }];
      ensureDatabases = [ "ret_prod" ];

    };

    users.users.hubs = {
      uid = config.ids.uids.hubs;
    };

    systemd.services.reticulum = with pkgs; {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "postgresql.service" ];
      requires = [ "network-online.target" "postgresql.service" ];

      description = "Reticulum (hubs backend)";

      environment = {
        # RELEASE_TMP is used to write the state of the
        # VM configuration when the system is running
        # it needs to be a writable directory
        # if you don't set it, it will default to /tmp
        RELEASE_TMP = cfg.workingDirectory;
        # MY_VAR = "my_var";
      };

      serviceConfig = {
        Type = "exec";
        User = "hubs";
        DynamicUser = true;
        WorkingDirectory = cfg.workingDirectory;
        # Implied by DynamicUser, but just to emphasize due to RELEASE_TMP
        PrivateTmp = true;
        ExecStart = ''
          ${reticulum}/bin/ret start
        '';
        ExecStop = ''
          ${reticulum}/bin/ret stop
        '';
        ExecReload = ''
          ${reticulum}/bin/ret restart
        '';
      };
      unitConfig = {
        Restart = "on-failure";
        RestartSec = 5;
        StartLimitBurst = 3;
        StartLimitInterval = 10;
      };
      # needed for disksup do have sh available
      path = [ pkgs.bash ];
    };

    environment.systemPackages = [ reticulum ];

    system.activationScripts.hubs = ''
      mkdir -p ${cfg.workingDirectory}
      chown hubs ${cfg.workingDirectory}
    '';

    ids.gids.hubs = 330;
    ids.uids.hubs = 330;
  };
}
