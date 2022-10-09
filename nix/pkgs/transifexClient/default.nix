# with import <nixpkgs> {};
with (import ../../dists).default.pkgs;
with python37.pkgs;

let

  transifexClient = python37.pkgs.callPackage ./transifexClient.nix { };

in transifexClient
