let

    dists = import ../../dists;
    pkgs = dists.default.pkgs;
    stdenv = pkgs.stdenv;

in stdenv.mkDerivation rec {

    name = "bknix-profile";
    src = ./src;
    buildInputs = [ pkgs.makeWrapper dists.local.pkgs.tzdata ];

    installPhase = ''
        mkdir -p $out/bin
        makeWrapper ${src}/bknix-profile $out/bin/bknix-profile \
          --set-default TZDIR ${pkgs.tzdata}/share/zoneinfo
    '';
}
