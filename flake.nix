{
  description = "OpenScreen - free, open-source alternative to Screen Studio";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          openscreen = pkgs.callPackage ./package.nix { };
          default = self.packages.${system}.openscreen;
        }
      );

      overlays.default = final: prev: {
        openscreen = self.packages.${final.system}.openscreen;
      };
    };
}
