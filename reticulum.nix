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

  erlang = beam.packages.erlang;
in
erlang.buildMix ({
  name = "reticulum";
  version = "unstable";

  src = hubsSrc.reticulum;

  depsSha256 = "sha256-3EitmpmQWpZq4Fm3zkliHHXOfuGslTDWCopS7VNCX/0=";

  buildInputs = [
    git
  ];

  /* configurePhase = ''
    type -Pf mix
    exit 2
  ''; */

  /* installPhase = ''
    mix ecto.create --no-deps-check
  ''; */

  /* buildInputs = extraPath ++ [

  ];

  inherit extraPath;

  nativeBuildInputs = [
    makeWrapper
  ];

  postBuild = ''
    for bin in $out/bin/*; do
      wrapProgram $bin --prefix PATH : ${lib.makeBinPath extraPath}
    done
  ''; */
})
