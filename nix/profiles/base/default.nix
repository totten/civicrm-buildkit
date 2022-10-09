/**
 * The `base` profile defines a series of common CLI utilities that rarely change.
 */
let
    ## Get "pkgs" for each known distro
    distPkgs = builtins.mapAttrs (name: value: value.pkgs) (import ../../dists);

in (with distPkgs; [
    default.bzip2
    local.bknixProfile
    default.curl
    default.gettext
    default.git
    default.gitAndTools.hub
    default.gnugrep
    default.gnused
    default.gnutar
    default.hostname
    default.moreutils
    default.ncurses
    default.patch
    default.rsync
    default.subversion
    local.tzdata
    default.unzip
    default.which
    default.zip
] ++ (if default.glibcLocales != null then [default.glibcLocales] else [] ))
