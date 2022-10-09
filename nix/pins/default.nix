rec {

  ## Typical block looks like this:
  #v9955 = rec {
  #  ## Download the raw source for v99.55.
  #  src = fetchTarball https://github.com/nixos/nixpkgs/archive/{{MY_GIT_REF}}.tar.gz;
  #
  #  ## Build a list of packages for v99.55 (with some specific configuration options).
  #  pkgs = import src {};
  #};

  v2205 = rec {
    src = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/ce6aa13369b667ac2542593170993504932eb836.tar.gz";
      sha256 = "0d643wp3l77hv2pmg2fi7vyxn4rwy0iyr8djcw1h5x72315ck9ik";
    };
    pkgs = import src {};
  };

  v2111 = rec {
    # v21.11, with official backports circa Dec 3 2021
    src = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/a7ecde854aee5c4c7cd6177f54a99d2c1ff28a31.tar.gz";
      sha256 = "162dywda2dvfj1248afxc45kcrg83appjd0nmdb541hl7rnncf02";
    };
    pkgs = import src {};
  };

  v2105 = rec {
    #  v21.05, with official backports circa Dec 3 2021
    src = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/7e9b0dff974c89e070da1ad85713ff3c20b0ca97.tar.gz";
      sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
    };
    pkgs = import src {};
  };

  v2009 = rec {
    src = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/cd63096d6d887d689543a0b97743d28995bc9bc3.tar.gz;
    pkgs = import src {};
  };

  v2003 = rec {
    src = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/70717a337f7ae4e486ba71a500367cad697e5f09.tar.gz;
    pkgs = import src {};
  };

  v1909 = rec {
    src = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/d5291756487d70bc336e33512a9baf9fa1788faf.tar.gz;
    pkgs = import src {};
  };

  v1903 = rec {
    src = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/34c7eb7545d155cc5b6f499b23a7cb1c96ab4d59.tar.gz;
    pkgs = import src {};
  };

  v1809 = rec {
    # src = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-18.09.tar.gz
    src = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/299814b385d2c1553f60ada8216d3b0af3d8d3c6.tar.gz;
    pkgs = import src {};
  };

  v1803 = rec {
    # src = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-18.03.tar.gz
    src = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/862fb5215f076833b74c7599fb4e8218d4dfeac2.tar.gz;
    pkgs = import src {};
  };

  bkit = import ../pkgs;
  default = v2205.pkgs;
}
