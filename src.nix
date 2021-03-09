
{ fetchFromGitHub }: {
  # nix-prefetch-github mozilla hubs --nix
  hubs = fetchFromGitHub {
        owner = "mozilla";
    repo = "hubs";
    rev = "a7cb5917765a8eb6a8bbc2d99e26fe3e47c878b0";
    sha256 = "5AROIpemHb0INCSize6fV5LLxoKXX2IXKbzuG5jYM0w=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla reticulum --nix
  reticulum = fetchFromGitHub {
        owner = "mozilla";
    repo = "reticulum";
    rev = "83924406e86cc2498535cd95d6c9ece5b0993af0";
    sha256 = "d6j0s2s8gu9T/AvsdZdIdfu+XvblyiWEWF8SI6HNdss=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla Spoke --nix
  spoke = fetchFromGitHub {
        owner = "mozilla";
    repo = "Spoke";
    rev = "213b909a4d795ac81cd9fdb7061efcc57c82b801";
    sha256 = "J/RRP2sNh12ghDe4t8X9cat1x9qlMKTWbHGgk5ahbSs=";
    fetchSubmodules = true;
  };
}

