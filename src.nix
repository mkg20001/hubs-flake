{ fetchFromGitHub }: {
  # nix-prefetch-github mozilla hubs --nix
  hubs = fetchFromGitHub {
    owner = "mozilla";
    repo = "hubs";
    rev = "5eb3a7bc9e5d13d5da7af15c5395f2056ab53c63";
    sha256 = "WUZ66fyk4ShFoAxVp8ixSGpxYebM6R4d2VBe3vWBMSI=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla reticulum --nix
  reticulum = fetchFromGitHub {
    owner = "mozilla";
    repo = "reticulum";
    rev = "ca443c520f5a2cb9f0e5da1367b72bddedc8a38a";
    sha256 = "5yrpF74J3D5yvl+7m9YcVZEl3yXwKF0E+qoV+MTq360=";
    fetchSubmodules = true;
  };
  # nix-prefetch-github mozilla Spoke --nix
  spoke = fetchFromGitHub {
    owner = "mozilla";
    repo = "Spoke";
    rev = "9c67be66faed2ed73506b5e966c0bbf90555eebd";
    sha256 = "7hI314VQ29Tly84GYrd10RVim0ZIFf1MGYHSSVvCbEo=";
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
