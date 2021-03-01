{ stdenv
, lib
, mkNode
, nodejs-14_x
, makeWrapper
, hubsSrc
}:

let
  extraPath = [

  ];
in
mkNode {
  root = hubsSrc.hubs;
  nodejs = nodejs-14_x;
  production = false;
  packageLock = "${hubsSrc.hubs}/package-lock.json";
} {
  buildInputs = extraPath ++ [

  ];

  inherit extraPath;

  nativeBuildInputs = [
    makeWrapper
  ];

  postBuild = ''
    for bin in $out/bin/*; do
      wrapProgram $bin --prefix PATH : ${lib.makeBinPath extraPath}
    done
  '';
}
