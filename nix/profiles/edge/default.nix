/**
 * The `max` list identifies the highest recommended versions of the system requirements.
 *
 * The `dists` var provides a list of major releases of Nix upstream (eg v19.09 <=> dists.v1909).
 */
let
    dists = import ../../dists;

in (import ../base/default.nix) ++ (import ../mgmt/default.nix) ++ [

    dists.bkit.php81
    dists.default.pkgs.nodejs-14_x
    dists.default.pkgs.apacheHttpd
    dists.default.pkgs.mailhog
    dists.default.pkgs.memcached
    /* dists.default.pkgs.mariadb */
    dists.default.pkgs.mysql80
    dists.default.pkgs.redis
    dists.bkit.transifexClient

]
