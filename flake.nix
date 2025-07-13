{
  description = "Todo Demo App using GJS and Gnim";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    nativeBuildInputs = with pkgs; [
      wrapGAppsHook
      pnpm.configHook
      pnpm
      gobject-introspection
      meson
      pkg-config
      ninja
      desktop-file-utils
    ];

    buildInputs = with pkgs; [
      gsettings-desktop-schemas
      glib
      libadwaita
      gtk4
      gjs
      esbuild
    ];
  in {
    packages.${system}. default = pkgs.stdenv.mkDerivation {
      pname = "todo-demo"; # FIXME: rename
      version = "0.0.0";
      src = ./.;

      inherit nativeBuildInputs buildInputs;

      pnpmDeps = pkgs.pnpm.fetchDeps {
        inherit (self.packages.${system}.default) pname version src;
        hash = "sha256-MfWRsOzFiVLLVkX6jiHCW7Z44yEtS3uDjdWYf6pbpW8=";
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      inherit nativeBuildInputs buildInputs;
    };
  };
}
