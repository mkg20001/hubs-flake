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

  /* postBuild = ''
    for bin in $out/bin/*; do
      wrapProgram $bin --prefix PATH : ${lib.makeBinPath extraPath}
    done
  ''; */
})
