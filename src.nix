{ fetchFromGitHub }: {
  # nix-prefetch-github mozilla hubs --nix
  hubs = fetchFromGitHub {
    owner = "mozilla";
    repo = "hubs";
    rev = "1d40a9e780544e80014b78b5e8f728b3ec2002c3";
    sha256 = "VX0WS3K4oN4vPeOdzKr1NmxGcF3ZyaF8UWqH2iLH6aM=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla reticulum --nix
  reticulum = fetchFromGitHub {
    owner = "mozilla";
    repo = "reticulum";
    rev = "deb1818f0bca4ae68e6b68659c59bdf487e55da0";
    sha256 = "U5yBhO99PNRYeG2k40uisSD8TtCeSnoLPJjskyAz/JA=";
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
