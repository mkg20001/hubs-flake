{ stdenv
, lib
, makeWrapper
, hubsSrc
, beam
, git
}:

let
  packages = beam.packagesWith beam.interpreters.erlang;
  src = hubsSrc.reticulum;

  pname = "reticulum";
  version = "unstable";
  mixEnv = "prod";

  mixFodDeps = packages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src mixEnv version;
    sha256 = "sha256-U4G1rKN9rcqA5g6C41UmLM8Fn69xs/QPOpMNd6mzrJQ=";

    MIX_ENV = "prod";
  };

in packages.mixRelease {
  inherit src pname version mixEnv mixFodDeps;

  MIX_ENV = "prod";
}

/* in packages.mixRelease {
  inherit src pname version mixEnv mixDeps;

  MIX_ENV = "prod";

  postPatch = ''
    sed "s|hostname: \"localhost\"|socket_dir: \"/run/postgresql\"|g" -i config/prod.exs
    sed "s|username: \"postgres\",|username: \"root\",|g" -i config/prod.exs
    sed "s|password: \"postgres\",|show_sensitive_data_on_connection_error: true,|g" -i config/prod.exs

    sed "s%password = session_lock_db_config |> Keyword.get(:password)%socket_dir = session_lock_db_config |> Keyword.get(:socket_dir)%" -i ./lib/ret/locking.ex
    sed "s|password: password,|socket_dir: socket_dir,|" -i ./lib/ret/locking.ex

    echo 'config :ret, Ret.Habitat, ip: "127.0.0.1", http_port: 9631' >> config/prod.exs

    sed 's|config :peerage, via: Ret.PeerageProvider||g' -i config/prod.exs

    cat config/prod.exs
  '';

  installPhase = ''
    runHook preInstall
    mix do compile --no-deps-check, distillery.release --env prod
    # MIX_ENV=prod mix distillery.release --no-deps-check
    mkdir -p $out
    cp -a _build/prod/rel/ret/* $out
    runHook postInstall
  '';
} */
