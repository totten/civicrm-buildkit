## Example usage:
##
## nix-build -A min && docker load < result && docker run -it bknix-min:latest /bin/bash
##
## git clone https://github.com/civicrm/civicrm-buildkit $HOME/tmp/qqq
## nix-build -A min && docker load < result && docker run -v $HOME/tmp/qqq:/srv -it bknix-min:latest /bin/bash
##
## See also:
##
## https://ryantm.github.io/nixpkgs/builders/images/dockertools/

let

    pkgs = (import ../pins).v2305;
    pkgsLinux = pkgs; # pkgsLinux ? import <nixpkgs> { system = "x86_64-linux" }
    stdenv = pkgs.stdenv;
    bkpkgs = import ../pkgs;
    profiles = import ../profiles;

in with pkgs.dockerTools; rec {

  base = buildImage {
    name = "bknix-base";
    tag = "latest";

    copyToRoot = [
      usrBinEnv
      binSh
      caCertificates
      fakeNss
    ];

    runAsRoot = ''
      #!${stdenv.shell}
      mkdir /tmp
      chmod 1777 /tmp
    '';
  };

  std = buildImage {
    name = "bknix-std";
    tag = "latest";

    fromImage = base;
    fromImageName = null;
    fromImageTag = "latest";

    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      paths = profiles.base ++ profiles.mgmt ++ profiles.shell;
      pathsToLink = [ "/share" "/bin" ];
    };

  };

  min = buildImage {
    name = "bknix-min";
    tag = "latest";

    fromImage = std;
    fromImageName = null;
    fromImageTag = "latest";

    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      paths = profiles.min;
      pathsToLink = [ "/share" "/bin" ];
    };

#    config = {
#      Cmd = [ "${bkpkgs.ramdisk}/bin/ramdisk help" ];
#    };
  };

  mind = buildNixShellImage {
    drv = (import ../default.nix).min;
  };

#  minc = buildContainer {
#    args = [
#      (with pkgs;
#        writeScript "run.sh" ''
#          #!${bash}/bin/bash
#          exec ${bash}/bin/bash
#        '').outPath
#    ];

#    mounts = {
#      "/data" = {
#        type = "none";
#        source = "/var/lib/mydata";
#        options = [ "bind" ];
#      };
#    };

#    readonly = false;
#  };

}
