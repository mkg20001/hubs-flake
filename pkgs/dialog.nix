{ stdenv
, lib
, mkNode
, nodejs-16_x
, hubsSrc
, makeWrapper
}:

mkNode {
  nodejs = nodejs-16_x;
  root = hubsSrc.dialog;
} {
  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    makeWrapper "${nodejs-16_x}/bin/npm" "$out/bin/dialog" \
      --run "cd $out" \
      --addFlags "start --"
  '';
}
