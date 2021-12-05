{ fetchFromGitHub }: {
  # nix-prefetch-github mozilla hubs --nix
  hubs = fetchFromGitHub {
    owner = "mozilla";
    repo = "hubs";
    rev = "57e94966d3f8be345c12196a93d19bd313217b1c";
    sha256 = "QrAIgLH6Iele+KDmwulXzMGMomsJ0jnjS1fACJGNgjI=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla reticulum --nix
  reticulum = fetchFromGitHub {
    owner = "mozilla";
    repo = "reticulum";
    rev = "4c2a1f1c542e63e4cec03798e71b4043603ef721";
    sha256 = "wQJAzCdfwMgtzUEwAPYK0gQ2fUifcXliPWFtrhDDi7U=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla Spoke --nix
  spoke = fetchFromGitHub {
    owner = "mozilla";
    repo = "Spoke";
    rev = "8aa84fce7d0ae8c46a4626767884cfb3aa0578d1";
    sha256 = "yQlH5cKVf55YzRSYnXAoh+3VSZH2hlbW+c1vr09T7v0=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozillareality youtube-dl-api-server --nix
  yt-dl-api-server = fetchFromGitHub {
    owner = "mozillareality";
    repo = "youtube-dl-api-server";
    rev = "8042ed2eba2adb0315af8880d0d53b8a7fe6ab7a";
    sha256 = "LH5qcB56LPY3PMARCzY5FzZ1eDkFLWGiqzCsqZN/uy4=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla dialog --nix
  dialog = fetchFromGitHub {
    owner = "mozilla";
    repo = "dialog";
    rev = "036466fda66f55be43e53403882a6d4235b839d4";
    sha256 = "Cqij4xCoYYAc2g48qGp0QibAQP0Ow4FGz6qL+MrFS54=";
    fetchSubmodules = true;
  };
}
