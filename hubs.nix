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

  depsHash = "sha256-X2rJ710dFwBy4djs4ZwXYGSy5TmKT9WumNvLxxjGcc4=";

  src = "${hubsSrc.hubs}";

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
    mv dist $out
  '';
}
