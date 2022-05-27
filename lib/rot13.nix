{ lib, pkgs, ... }:
let inherit (builtins) replaceStrings;
    inherit (pkgs.lib) stringToCharacters;
in
{
  rot13 = s:
    replaceStrings
      (stringToCharacters "abcdefghijklmnopqrstuvwxyz")
      (stringToCharacters "nopqrstuvwxyzabcdefghijklm")
      s;
}
