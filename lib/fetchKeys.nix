{ lib, ... }:
with builtins;
with lib; {
  lines = splitString "\n";
  fetchKeys = user:
    lines (readFile (fetchurl "https://github.com/${user}.keys"));
}
