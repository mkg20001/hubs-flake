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
}
