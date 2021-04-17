{ fetchFromGitHub }: {
  # nix-prefetch-github mozilla hubs --nix
  hubs = fetchFromGitHub {
    owner = "mozilla";
    repo = "hubs";
    rev = "614818eb2a1c3b23b49700a2023709a86532e283";
    sha256 = "LtvlDxjkQyskDjDEZOo0Zmju0FNpf1aoMJj6sga/5xg=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla reticulum --nix
  reticulum = fetchFromGitHub {
    owner = "mozilla";
    repo = "reticulum";
    rev = "6836cdfa0fd3a83fb10fc2460d6bb24501925877";
    sha256 = "mEWEqpqCd7A1HHgXuMwCkSsIiN4xnlOXstoU34vKfF4=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla Spoke --nix
  spoke = fetchFromGitHub {
    owner = "mozilla";
    repo = "Spoke";
    rev = "195dcdfdab4aa3e8526610eada9920ede54c696f";
    sha256 = "kQlt5tGoP33PmRM3wv6Jr9dmTwkkD2EO+kqEfw2sFM4=";
    fetchSubmodules = true;
  };
}
