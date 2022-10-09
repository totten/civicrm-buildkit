/**
 * The `min` list identifies the lowest recommended versions of the system requirements.
 *
 * We rely on a mix of packages from Nix upstream v18.03 and custom forks  (`default.*`, `v1803.*`, `local.*`).
 */
let
    ## Get "pkgs" for each known distro
    distPkgs = builtins.mapAttrs (name: value: value.pkgs) (import ../../dists);

in (import ../base/default.nix) ++ (import ../mgmt/default.nix) ++ (with distPkgs; [

    local.php71
    default.nodejs-14_x
    default.apacheHttpd
    default.mailhog
    v1803.memcached
    local.mysql56
    v1803.redis
    local.transifexClient

])
