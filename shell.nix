{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/88a55dffa4d44d294c74c298daf75824dc0aafb5.tar.gz") {}
}:
let
  stdenv = pkgs.llvmPackages.stdenv;
in
stdenv.mkDerivation rec {
  pname = "srsran";
  version = "24.10.1";

  src = pkgs.fetchFromGitHub {
    owner = "srsran";
    repo = "srsRAN_Project";
    rev = "release_${builtins.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-ufU6j/OuB+H0XlutIpPrgO9TCLzdDP5nDMAqQlDZ0Mk=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    mold
  ];

  buildInputs = with pkgs; [
    fftwFloat
    mbedtls
    boost
    libconfig
    lksctp-tools
    pcsclite
    uhd
    soapysdr-with-plugins
    libbladeRF
    zeromq

    fftw
    yaml-cpp
    mbedtls
    gtest
    lksctp-tools
  ];

  NIX_LDFLAGS = "-fuse-ld=mold";
  CFLAGS = "-Wno-unused-command-line-argument";
  CXXFLAGS = "-Wno-unused-command-line-argument";

  cmakeFlags = [ "-DENABLE_WERROR=OFF" ];
}
