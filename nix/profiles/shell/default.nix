/**
 * The `shell` profile provides utilities for interactive shell usage.
 * These are not functionally required and could be omitted in headless
 * arrangements.
 */
let
    dists = import ../../pins;
in [
    dists.default.bashInteractive
    dists.default.nano
    dists.default.joe
]
