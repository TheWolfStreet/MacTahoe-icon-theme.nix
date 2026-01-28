{
  description = "MacTahoe icon theme";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      for_all = f:
        nixpkgs.lib.genAttrs systems (system:
          f (import nixpkgs { inherit system; }));
    in {
      packages = for_all (pkgs:
        let
          pname = "MacTahoe-icon-theme";
        in {
          default =
            pkgs.lib.checkListOfEnum "${pname}: theme variants"
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
              []
              pkgs.stdenvNoCC.mkDerivation rec {
                inherit pname;
                version = "2025-10-16";

                src = pkgs.fetchFromGitHub {
                  owner = "vinceliuice";
                  repo = "MacTahoe-icon-theme";
                  tag = version;
                  hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                };

                nativeBuildInputs = [
                  pkgs.gtk3
                  pkgs.jdupes
                ];

                buildInputs = [
                  pkgs.hicolor-icon-theme
                ];

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
                    --theme default \

                  jdupes --link-soft --recurse $out/share

                  runHook postInstall
                '';

                meta = {
                  description = "MacOS Tahoe icon theme for linux";
                  homepage = "https://github.com/vinceliuice/MacTahoe-icon-theme";
                  license = pkgs.lib.licenses.gpl3Plus;
                  platforms = pkgs.lib.platforms.linux;
                  maintainers = [ "TheWolfStreet" ];
                };
              };
        });
    };
}
