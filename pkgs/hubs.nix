{ stdenv
, lib
, mkNodeFod
, nodejs-14_x
, hubsSrc
}:

mkNodeFod {
  pname = "hubs";
  version = "unstable";

  node = nodejs-14_x;

  depsHash = "sha256-d1DMMnjdXg2BguhYWW5FUvY1sQbknDpvfx8MTsPabyI=";

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
