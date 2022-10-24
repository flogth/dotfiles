{ lib, ... }:
with builtins;
with lib; rec {
  lines = splitString "\n";
  fetchKeys = user: sha256:
    lines (readFile (fetchurl {
      inherit sha256;
      url = "https://github.com/${user}.keys";
    }));
}
