{
  description = "Kye's nix flakes";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: 

    flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages = rec {
          gbdk = with pkgs; stdenv.mkDerivation {
            version = "4.0.6";
            name = "gbdk-2020";

            src = fetchTarball {
              url = "https://github.com/gbdk-2020/gbdk-2020/releases/download/4.0.6/gbdk-linux64.tar.gz";
              sha256 = "sha256:1w68a1aplljc0jn834k02dd18rf3vziddyylywz7pppr8y3pd5vj";
            };

            nativeBuildInputs = [
              autoPatchelfHook
            ];

            buildInputs = [
              zlib.dev
              stdenv.cc.cc.lib
            ];

            installPhase = ''
              mkdir -p $out/bin
              cp bin/* $out/bin
            '';

          };
          swift-mint = with pkgs; stdenv.mkDerivation {
            version = "0.17.0";
            name = "swift-mint";

      src = pkgs.fetchFromGitHub { 
        owner = "yonaskolb";
        repo = "Mint";
        rev = "0.17.0";
        sha256 = "sha256-Ee0SrEclT6q3jR9IFJJm3wrWMncrk6DDf5eBmpCmbSc=";
      };

      buildInputs = [ cacert git clang swift unzip ];

      buildPhase = ''
        export HOME=$(pwd)
        export SSL_CERT_FILE="${cacert.out}/etc/ssl/certs/ca-bundle.crt";
        swift build --verbose -c release
      '';

      installPhase = ''
        install -m755 -D $(swift build -c release --show-bin-path)/mint $out/bin/mint
       '';

       meta = with nixpkgs.lib; {
         homepage = "https://github.com/yonaskolb/Mint";
         description = "A package manager that installs and runs Swift command line tool packages.";
         platform = platforms.linux;
       };

       outputHashMode = "recursive";
       outputHashAlgo = "sha256";
       outputHash = "sha256-1CENy1pE36Sq0U64tOyURAS6LFqk8gq3UaBXuHqLLy0";

     };
   };
 });
}
