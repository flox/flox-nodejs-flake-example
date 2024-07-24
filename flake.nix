{
  description = "Flake for Node.js v20.13.1";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          nodejsFor = {
            x86_64-linux = {
              url = "https://nodejs.org/dist/v20.13.1/node-v20.13.1-linux-x64.tar.xz";
              sha256 = "sha256-78Dyld2HjlEKsS6ja7rcPbA8aHqzDAfobHzbp+7Yeak=";
            };
            x86_64-darwin = {
              url = "https://nodejs.org/dist/v20.13.1/node-v20.13.1-darwin-x64.tar.gz";
              sha256 = "sha256-gL3pXcl2uE21ylZnOMBzBQh65Xj187BRkeDm/1Sq6vI=";
            };
            aarch64-darwin = {
              url = "https://nodejs.org/dist/v20.13.1/node-v20.13.1-darwin-arm64.tar.gz";
              sha256 = "sha256-ww/llfWdzSxRWNpr+LwlH/yFyjcwSvqJ2xUPs8YsRQc=";
            };
            aarch64-linux = {
              url = "https://nodejs.org/dist/v20.13.1/node-v20.13.1-linux-arm64.tar.xz";
              sha256 = "sha256-T5wv+xFoVdb6S2ZU5FP0A+MbUyhLgceJtz0dLiDG9xA=";
            };
          };
          nodejs = pkgs.stdenv.mkDerivation {
            pname = "nodejs";
            version = "20.13.1";
            src = pkgs.fetchurl (nodejsFor.${system});
            buildInputs = [ pkgs.stdenv ];
            installPhase = ''
              mkdir -p $out
              cp -r * $out/
            '';
          };
        in
        {
          default = nodejs;
        }
      );
    };
}

