/**
 * The `mgmt` profile provides bknix's process management utilities for
 * starting/stopping daemons.
 *
 * At time of writing, this profile represents the main difference between
 * the branches `master` and `master-loco`
 */
let
    ## Get "pkgs" for each known distro
    distPkgs = builtins.mapAttrs (name: value: value.pkgs) (import ../../dists);
in (with distPkgs; [
    local.bknixPhpstormAdvisor
    local.loco
    local.ramdisk
])
