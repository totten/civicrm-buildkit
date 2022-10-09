/**
 * The `dfl` list identifies the lowest recommended versions of the system requirements.
 *
 * The `dists` var provides a list of major releases of Nix upstream (eg v19.09 <=> dists.v1909).
 */
let
    dists = import ../../dists;
    stdenv = dists.default.pkgs.stdenv;
    ## Some older packages aren't buildable on Apple M1, so we use closest match.
    isAppleM1 = stdenv.isDarwin && stdenv.isAarch64;

in (import ../base/default.nix) ++ (import ../mgmt/default.nix) ++ [

    dists.local.pkgs.php80
    dists.default.pkgs.nodejs-14_x
    dists.default.pkgs.apacheHttpd
    dists.default.pkgs.mailhog
    dists.default.pkgs.memcached
    (if isAppleM1 then dists.default.pkgs.mysql80 else dists.default.pkgs.mysql57)
    dists.default.pkgs.redis
    dists.local.pkgs.transifexClient

]
