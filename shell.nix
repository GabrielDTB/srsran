{
  # Pinned version of nixpkgs unstable on 2024/01/27.
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/88a55dffa4d44d294c74c298daf75824dc0aafb5.tar.gz") {}
}:
let
  # Use Clang for faster compiles.
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
    # Use mold for faster linking.
    mold
  ];

  buildInputs = with pkgs; [
    fftwFloat
    fftw
    yaml-cpp
    mbedtls
    gtest
    lksctp-tools
  ];

  # Use mold for faster linking.
  NIX_LDFLAGS = "-fuse-ld=mold";
  CFLAGS = "-Wno-unused-command-line-argument";
  CXXFLAGS = "-Wno-unused-command-line-argument";

  # Breaking purity is required because srsRAN compilation depends
  # on the instruction set of the compiling computer.
  NIX_ENFORCE_NO_NATIVE = "0";

  cmakeFlags = [ "-DENABLE_WERROR=OFF" ];
}
