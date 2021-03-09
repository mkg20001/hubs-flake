{ stdenv
, lib
, nodejs-14_x
, makeWrapper
, hubsSrc
, beam
, git
}:

let
  extraPath = [

  ];
in
beam.packages.erlang.buildMix ({
  name = "reticulum";
  version = "unstable";

  src = hubsSrc.reticulum;

  depsSha256 = "sha256-3EitmpmQWpZq4Fm3zkliHHXOfuGslTDWCopS7VNCX/0=";

  buildInputs = [
    git
  ];

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
    mix do compile --no-deps-check, distillery.release
    mkdir -p $out
    cp -a _build/prod/rel/ret/* $out
    runHook postInstall
  '';

  /* postBuild = ''
    for bin in $out/bin/*; do
      wrapProgram $bin --prefix PATH : ${lib.makeBinPath extraPath}
    done
  ''; */
})
