{ pkgs, ... }: {
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = builtins.attrValues {
      inherit (pkgs) fira julia-mono lmodern;
    };
  };
}
