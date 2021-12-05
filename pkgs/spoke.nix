{ stdenv
, lib
, mkNodeFod
, nodejs-14_x
, hubsSrc
}:

mkNodeFod {
  pname = "spoke";
  version = "unstable";

  node = nodejs-14_x;

  useYarn = true;
  depsHash = "sha256-lF1KPIAbyG2pL8wNrN6jh7JRrf+51BKCt99X4a62aZY=";

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
