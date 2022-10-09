/**
 * The `min` list identifies the lowest recommended versions of the system requirements.
 *
 * The `distPkgs` var provides a list of major releases of Nix upstream (eg v19.09 <=> distPkgs.v1909).
 */
let
    ## Get "pkgs" for each known distro
    distPkgs = builtins.mapAttrs (name: value: value.pkgs) (import ../../dists);
    stdenv = distPkgs.default.stdenv;
    ## Some older packages aren't buildable on Apple M1, so we use closest match.
    isAppleM1 = stdenv.isDarwin && stdenv.isAarch64;

in (import ../base/default.nix) ++ (import ../mgmt/default.nix) ++ (with distPkgs; [

    (if isAppleM1 then local.php74 else local.php72)
    default.nodejs-14_x
    default.apacheHttpd
    default.mailhog
    default.memcached
    (if isAppleM1 then default.mysql80 else default.mysql57)
    default.redis
    local.transifexClient

])
