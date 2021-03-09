{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hubs;
  reticulum = pkgs.reticulum;
  configJSON = builtins.toJSON cfg.config;
in
{
  imports = [
    ./janus.nix
  ];

  options = {
    services.hubs = {
      enable = mkEnableOption "Mozilla Hubs";
      workingDirectory = mkOption {
        type = types.str;
        default = "/var/reticulum";
      };

      config = mkOption {
        type = types.attrs;
      };

      domain = mkOption {
        type = types.str;
        description = "Set domain for hubs services";
        default = "hubs.local";
      };

      enableNginx = mkOption {
        type = types.bool;
        default = false;
        description = "Setup nginx to serve hubs services";
      };

      enableAcme = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Let's Encrypt SSL Certificates";
      };

      enableAcmeNginx = mkOption {
        type = types.bool;
        default = cfg.enableAcme && cfg.enableNginx;
        description = "Enable Let's Encrypt SSL Certificates for nginx (requires enableAcme & enableNginx)";
      };
    };
  };

  config = mkIf (cfg.enable) {

    services.nginx = mkIf (cfg.enableNginx) {
      enable = true;
    };

    services.hubs.config = {
      ret = {
        "Elixir.Ret" = {
          pool = "default";
        };

        "Elixir.RetWeb.Plugs.HeaderAuthorization" = {
          header_value = "@@secret_phx_admin_key@@";
        };


        "Elixir.RetWeb.Endpoint".https = {
          port = "4544";
          # certfile
          # cacertfile
          # keyfile
        };

        "Elixir.RetWeb.Endpoint" = {
          allowed_origins = "*";
          secret_key_base = "@@phx_secret_base@@";
          allow_crawlers = true;
        };


        "Elixir.Ret.Repo" = {
          username = "root";
          database = "ret_production";
          socket_dir = "/run/postgresql";
          template = "template0";
          pool_size = 16;
        };

        "Elixir.Ret.SessionLockRepo" = {
          username = "root";
          database = "ret_production";
          socket_dir = "/run/postgresql";
          template = "template0";
          pool_size = 16;
        };


        "Elixir.Ret.Locking".session_lock_db = {
          username = "root";
          database = "ret_production";
          socket_dir = "/run/postgresql";
          template = "template0";
          pool_size = 16;
        };


        "Elixir.Ret.Guardian" = {
          secret_key = "@@guardian_secret@@";
        };

        "Elixir.Ret.PermsToken" = {
          perms_key = "@@permstoken@@";
        };

        bot_access_key = "@@bot_access_key@@";


        "Elixir.Ret.PageOriginWarmer" = {
          # pkgs.hubs.client
          hubs_page_origin = "https://${cfg.domain}/_assets/client";
          # pkgs.spoke.out
          spoke_page_origin = "https://${cfg.domain}/_assets/spoke";
          # pkgs.hubs.admin
          admin_page_origin = "https://${cfg.domain}/_assets/admin";
        };

        "Elixir.Ret.HttpUtils" = {
          insecure_ssl = !cfg.enableAcme;
        };


      run = {
        hostname_dns_suffix = cfg.domain;
      };

      hackney = {
        max_connections = 50;
      };
    };

    services.postgresql = {
      enable = true;
      # TODO: setup reticulum db

      ensureUsers = [{
        name = "hubs";
        ensurePermissions = { "DATABASE ret_production" = "ALL PRIVILEGES"; };
      }];
      ensureDatabases = [ "ret_production" ];

    };

    services.janus = {
      enable = true;
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

script = ''
export HOME="$RELEASE_TMP"
export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export REPLACE_OS_VARS=true # Inlines OS vars into vm args
export MIX_ENV=prod

SECRET_DIR="$RELEASE_TMP/secret"
RELEASE_CONFIG_DIR="$RELEASE_TMP/config"

CONFIG=$(echo ${escapeShellArg configJSON})

mkdir -p "$SECRET_DIR"

ulimit -a

for sec in $(echo "$CONFIG" | grep -o "@@[a-zA-Z_][a-zA-Z_]*@@"); do
  sec=''${sec//"@@"/""}
  if [ ! -e "$SECRET_DIR/$sec" ]; then
    dd if=/dev/urandom of=/dev/stdout count=64 bs=1 2>/dev/null | base64 -w 0 > "$SECRET_DIR/$sec"
  fi
  secv=$(cat "$SECRET_DIR/$sec")
  CONFIG=''${CONFIG//"@@$sec@@"/"$secv"}
done

if [ ! -e "$RELEASE_TMP/.erlang.cookie" ]; then
  dd if=/dev/urandom of=/dev/stdout count=64 bs=1 2>/dev/null | base64 -w 0 > "$RELEASE_TMP/.erlang.cookie"
  chmod 0400 "$RELEASE_TMP/.erlang.cookie"
fi

rm -rf "$RELEASE_CONFIG_DIR"
mkdir "$RELEASE_CONFIG_DIR"
echo "$CONFIG" | ${pkgs.yj}/bin/yj -jt > "$RELEASE_CONFIG_DIR/config.toml"

export PATH=${lib.makeBinPath (with pkgs; [ gawk bash coreutils gnused gnugrep ])}

export NODE_NAME=$(echo "$HOSTNAME") # $(echo $HOSTNAME | sed "s|\\..+||g")
export NODE_COOKIE="$NODE_NAME.cookie"

RELEASE_MUTABLE_DIR="$RELEASE_TMP/mutable" RELEASE_CONFIG_DIR="$RELEASE_TMP/config" ${reticulum}/bin/ret start
'';
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
      path = [ pkgs.bash pkgs.gawk ];
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
