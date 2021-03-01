{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hubs;
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
    services.postgres = {
      enable = true;
      # TODO: setup recticulum db
    };

    systemd.services.reticulum = with pkgs; {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "postgresql.service" ];
      requires = [ "network-online.target" "postgresql.service" ];
      description = "Reticulum (hubs backend)";
      serviceConfig = {
        Type = "exec";
        DynamicUser = true;
        WorkingDirectory = cfg.workingDirectory;
        # Implied by DynamicUser, but just to emphasize due to RELEASE_TMP
        PrivateTmp = true;
        ExecStart = ''
          mkdir -p ${cfg.workingDirectory}
          ${reticulum}/bin/ret start
        '';
        ExecStop = ''
          ${reticulum}/bin/ret stop
        '';
        ExecReload = ''
          ${reticulum}/bin/ret restart
        '';
        Restart = "on-failure";
        RestartSec = 5;
        StartLimitBurst = 3;
        StartLimitInterval = 10;
        environment = {
          # RELEASE_TMP is used to write the state of the
          # VM configuration when the system is running
          # it needs to be a writable directory
          # if you don't set it, it will default to /tmp
          RELEASE_TMP = cfg.workingDirectory;
          # MY_VAR = "my_var";
        };
      };
      # needed for disksup do have sh available
      path = [ pkgs.bash ];
    };

    environment.systemPackages = [ release ];
  };
}