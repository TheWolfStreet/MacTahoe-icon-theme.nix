{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  jdupes,
  boldPanelIcons ? false,
  themeVariants ? [],
}: let
  pname = "MacTahoe-icon-theme";
in
  lib.checkListOfEnum "${pname}: theme variants"
  [
    "default"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "grey"
    "all"
  ]
  themeVariants
  stdenvNoCC.mkDerivation
  rec {
    inherit pname;
    version = "2025-10-16";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "MacTahoe-icon-theme";
      tag = version;
      hash = "sha256-oBKDvCVHEjN6JT0r0G+VndzijEWU9L8AvDhHQTmw2E4=";
    };

    nativeBuildInputs = [
      gtk3
      jdupes
    ];

    buildInputs = [hicolor-icon-theme];

    # These fixup steps are slow and unnecessary
    dontPatchELF = true;
    dontRewriteSymlinks = true;
    dontDropIconThemeCache = true;

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      ./install.sh --dest $out/share/icons \
        --name MacTahoe \
        --theme ${toString themeVariants} \
        ${lib.optionalString boldPanelIcons "--bold"} \

      jdupes --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = {
      description = "MacOS Tahoe icon theme for linux ";
      homepage = "https://github.com/vinceliuice/MacTahoe-icon-theme";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.linux;
      maintainers = "TheWolfStreet";
    };
  }
