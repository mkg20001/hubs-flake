{ stdenv
, fetchFromGitHub
, autoreconfHook
, curl
, glib
, libnice
, srtp
, m4
, pkg-config
, jansson
, libconfig
, gengetopt
, libogg
, lksctp-tools
}:

stdenv.mkDerivation rec {
  name = "janus";
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "meetecho";
    repo = "janus-gateway";
    rev = "v${version}";
    sha256 = "aMyae2jpP4ipgRl5Mp2m0v2M4PQtss3EeAil/MWfYrs=";
    fetchSubmodules = true;
  };

  buildInputs = [
    curl
    glib
    libnice
    srtp
    libconfig
    jansson
    libogg
    lksctp-tools
  ];

  nativeBuildInputs = [
    autoreconfHook
    curl.dev
    m4
    pkg-config
    gengetopt
  ];
}
