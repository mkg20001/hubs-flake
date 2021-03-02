{ stdenv
, lib
, mkNodeFod
, nodejs-14_x
, hubsSrc
}:

mkNodeFod {
  pname = "hubs-admin";
  version = "unstable";

  node = nodejs-14_x;

  depsHash = "sha256-Uv8x5UoL+eqYiXB2S43XCZGviyL04vYjvYSzhJ2a1kg=";

  src = "${hubsSrc.hubs}/admin";

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
    mv dist $out
  '';
}
