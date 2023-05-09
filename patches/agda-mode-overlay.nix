self: super:
{
  agda = super.agda.overrideAttrs (old: {
    patches = (old.patches or []) ++
    [ ./agda-mode.patch ];
  });
}
