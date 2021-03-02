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

  depsSha256 = "xRTetJBJ/NYl+yQlxYRNcJT1JkbEEK0r8TC3RLpOMmI=";

  src = "${hubsSrc.hubs}";

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
    mv dist $out
  '';
}
