{ lib
, python3
, hubsSrc
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "youtube-dl-api-server";
  version = "unstable";

  src = hubsSrc.yt-dl-server;

  propagatedBuildInputs = [
    youtube-dl
    flask
  ];
}
