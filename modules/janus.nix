{ config, lib, pkgs, ... }:

with lib;

# TODO: patch protected_folders to add some sanity
# and make it a whitelist (allowed_folders)

let
  cfg = config.services.janus;
  janus = pkgs.janus;
  jcfgStr = import ./jcfg-str.nix lib;
  combined = janus; # TODO: make derivation that combines plugins and janus
in
{
  options = {
    services.janus = {
      enable = mkEnableOption "Janus WebRTC";
      config = mkOption {
        description = "Janus Options";
        type = types.attrsOf (types.attrs);
      };
      # plugins = listOf packages
    };
  };

  config = mkIf (cfg.enable) {
    users.users.janus = {
      uid = config.ids.uids.janus;
    };

    environment.etc = mapAttrs' (key: value: nameValuePair ("janus/${key}.jcfg") ({
      text = jcfgStr value;
      })) cfg.config;

    services.janus.config = {
      janus = {
        # defaults from ${janus}/etc/janus.jcfg.sample
        general = {
          configs_folder = "/etc/janus";
          plugins_folder = "${combined}/lib/janus/plugins";
          transports_folder = "${combined}/lib/janus/transports";
          events_folder = "${combined}/lib/janus/events";
          loggers_folder = "${combined}/lib/janus/loggers";

          debug_level = 4;

          protected_folders = ["/"];
        };

        nat = {
          nice_debug = false;
          ice_ignore_list = "vmnet";
        };
      };

      "janus.eventhandler.gelfevh" = {};
      "janus.eventhandler.sampleevh" = {};

      "janus.plugin.echotest" = {};
      "janus.plugin.nosip" = {};
      "janus.plugin.recordplay" = {
        general.path = "/var/janus/recordings";
      };
      "janus.plugin.streaming" = {};
      "janus.plugin.textroom" = {};
      "janus.plugin.videocall" = {};
      "janus.plugin.voicemail" = {};
      "janus.plugin.videoroom" = {};

      "janus.transport.pfunix" = {
        general = {
          enabled = true;
          json = "indented";
          path = "/run/janus.sock";
        };
      };
    };

    systemd.services.janus = with pkgs; {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network-online.target" ];

      description = "Janus WebRTC";

      serviceConfig = {
        Type = "simple";
        # User = "janus";
        Restart = "on-abnormal";
        ExecStart = "${janus}/bin/janus -o -F /etc/janus";
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
