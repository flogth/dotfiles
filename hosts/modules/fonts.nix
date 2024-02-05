{ pkgs, ... }: {
  fonts = {
    enableDefaultPackages = true;
    packages = builtins.attrValues {
      inherit (pkgs) fira julia-mono lmodern;
    };
  };
}
