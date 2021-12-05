{ fetchFromGitHub }: {
  # nix-prefetch-github mozilla hubs --nix
  hubs = fetchFromGitHub {
    owner = "mozilla";
    repo = "hubs";
    rev = "92468db796a1f7d79ba46b6ef62bcf40c5003980";
    sha256 = "s8sye0TxPnL4rY/ZrkMeIEZV7efOY1i8060Pkvj9nLE=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla reticulum --nix
  reticulum = fetchFromGitHub {
    owner = "mozilla";
    repo = "reticulum";
    rev = "b5680121d3ade221d6d3f862ff1fc9a70bdfcd99";
    sha256 = "L2CreOhez2yOhzVOJin/pyuX63gbdt+Z/zwKgpIsPd4=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla Spoke --nix
  spoke = fetchFromGitHub {
    owner = "mozilla";
    repo = "Spoke";
    rev = "ff546df26ebcb5ef45ed62824ed0a7feb7cb2613";
    sha256 = "E3jD5fUf9Mxvkt67/PXkTlzXiP94kh8HsGjRXA3ZFLs=";
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
}
