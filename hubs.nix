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

  depsHash = "sha256-ao5Ay+nfdtbviOaQnSdp4wl/1o2UTR5jwl4qdrGoDk0=";

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
    mv dist $client
    mv admin/dist $admin
  '';
}
