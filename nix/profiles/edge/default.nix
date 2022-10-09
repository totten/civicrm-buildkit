/**
 * The `max` list identifies the highest recommended versions of the system requirements.
 *
 * The `distPkgs` var provides a list of major releases of Nix upstream (eg v19.09 <=> distPkgs.v1909).
 */
let
    ## Get "pkgs" for each known distro
    distPkgs = builtins.mapAttrs (name: value: value.pkgs) (import ../../dists);

in (import ../base/default.nix) ++ (import ../mgmt/default.nix) ++ (with distPkgs; [

    local.php81
    default.nodejs-14_x
    default.apacheHttpd
    default.mailhog
    default.memcached
    /* default.mariadb */
    default.mysql80
    default.redis
    local.transifexClient

])
