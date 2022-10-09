/**
 * The `mgmt` profile provides bknix's process management utilities for
 * starting/stopping daemons.
 *
 * At time of writing, this profile represents the main difference between
 * the branches `master` and `master-loco`
 */
let
    dists = import ../../dists;
in [
    dists.local.pkgs.bknixPhpstormAdvisor
    dists.local.pkgs.loco
    dists.local.pkgs.ramdisk
]
