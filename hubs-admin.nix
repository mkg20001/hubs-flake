{ stdenv
, lib
, mkNode
, nodejs-14_x
, hubsSrc
}:

mkNode {
  root = "${hubsSrc.hubs}/admin";
  nodejs = nodejs-14_x;
  production = false;
  packageLock = "${hubsSrc.hubs}/admin/package-lock.json";
} {
  pname = "hubs-admin";

  buildPhase = ''
    npm run build
  '';

  nodeInstallPhase = ''
    mv dist $out
  '';
}
