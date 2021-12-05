{ stdenv
, lib
, mkNodeFod
, nodejs-16_x
, hubsSrc
}:

mkNodeFod {
  pname = "hubs";
  version = "unstable";

  node = nodejs-16_x;

  depsHash = "sha256-AsSjCQxA8nI0Whq3JlsGZDKkm9o61ynG/XjXB1b3sqM=";

  src = hubsSrc.hubs;

  outputs = [ "out" "client" "admin" ];

  depsAttrs.preInstall = ''
    pushd admin
    HOME=/tmp npm ci
    popd
  '';

  buildPhase = ''
    npm run build
    pushd admin
    npm run build
    popd
  '';

  installPhase = ''
    mkdir -p $out
    touch $out/void
    mv dist $client
    mv admin/dist $admin
  '';
}
