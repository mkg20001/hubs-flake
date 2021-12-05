{ stdenv
, lib
, mkNodeFod
, nodejs-16_x
, hubsSrc
}:

mkNodeFod {
  pname = "spoke";
  version = "unstable";

  node = nodejs-16_x;

  useYarn = true;
  depsHash = "sha256-kYLfjJkuKg7RBOfslMuHfpRBr3RuGTsAewvpMIbn6bE=";

  src = hubsSrc.spoke;

  # fix run-s
  depsAttrs.preConfigure = ''
    YG=$(mktemp -d)
    export PATH="$YG/.yarn/bin:$PATH"
    HOME="$YG" yarn global add npm-run-all
    patchShebangs "$YG"
  '';

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
    mv dist $out
  '';
}
