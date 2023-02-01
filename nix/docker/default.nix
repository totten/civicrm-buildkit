## Example usage:
##
## nix-build -A min && docker load < result && docker run -it bknix-min:latest /bin/bash
##
## See also:
##
## https://ryantm.github.io/nixpkgs/builders/images/dockertools/

let

    pkgs = (import ../pins).default;
    pkgsLinux = pkgs; # pkgsLinux ? import <nixpkgs> { system = "x86_64-linux" }
    stdenv = pkgs.stdenv;
    bkpkgs = import ../pkgs;
    profiles = import ../profiles;

in with pkgs.dockerTools; rec {

  base = buildImage {
    name = "bknix-base";
    tag = "latest";

    contents = [
      usrBinEnv
      binSh
#      caCertificates
      fakeNss
    ];
  };

  std = buildImage {
    name = "bknix-std";
    tag = "latest";

    fromImage = base;
    fromImageName = null;
    fromImageTag = "latest";

    contents = pkgs.buildEnv {
      name = "image-root";
      paths = [
        pkgs.coreutils
        pkgs.bashInteractive
      ] ++ profiles.base ++ profiles.mgmt;
      pathsToLink = [ "/bin" ];
    };

  };

  min = buildImage {
    name = "bknix-min";
    tag = "latest";

    fromImage = std;
    fromImageName = null;
    fromImageTag = "latest";

    contents = pkgs.buildEnv {
      name = "image-root";
      paths = [
        bkpkgs.php73
        pkgs.apacheHttpd
        pkgs.mailhog
        pkgs.memcached
        pkgs.mysql57
        pkgs.redis
      ];
      pathsToLink = [ "/bin" ];
    };

#    config = {
#      Cmd = [ "${bkpkgs.ramdisk}/bin/ramdisk help" ];
#    };
  };

}